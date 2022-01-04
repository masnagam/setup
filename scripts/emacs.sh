if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing emacs..."

MOZC_BUILDENV_DOCKERFILE_URL='https://raw.githubusercontent.com/google/mozc/master/docker/ubuntu20.04/Dockerfile'

MOZC_BUILDENV_OUTPUT_BINARY=$(mktemp)
cat <<EOF >$MOZC_BUILDENV_OUTPUT_BINARY
#!/bin/sh -eux
bazel build //unix/emacs:mozc_emacs_helper --config oss_linux -c opt
cat ./bazel-bin/unix/emacs/mozc_emacs_helper
EOF
chmod +x $MOZC_BUILDENV_OUTPUT_BINARY

cleanup() {
  /bin/rm -f $MOZC_BUILDENV_OUTPUT_BINARY
  if which docker >/dev/null 2>&1
  then
    sudo docker image rm mozc_buildenv || true
  fi
}

trap cleanup EXIT

# straight.el requires git.

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    if ! which git >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/git.sh | sh
    fi
    if ! which docker >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/docker.sh | sh
    fi
    paru -S --noconfirm emacs
    paru -S --noconfirm clang  # includes clangd
    paru -S --noconfirm aspell aspell-en ripgrep w3m
    # Remove mozc_emacs_helper if you like to install the latest version.
    if [ ! -x $HOME/bin/mozc_emacs_helper ]
    then
      mkdir -p $HOME/bin
      # mozc_emacs_helper is contained in emacs-mozc, but it conflicts with
      # fcitx-mozc.  We build mozc_emacs_helper using docker as described in the
      # following page:
      # https://github.com/google/mozc/blob/master/docs/build_mozc_in_docker.md
      curl -fsSL $MOZC_BUILDENV_DOCKERFILE_URL | \
        sudo docker build --rm -t mozc_buildenv -
      # The following command doesn't work properly:
      #
      #   sudo docker run ... mozc_buildenv sh -c 'bazel build ...'
      #
      # As a workaround, we make a temporal scirpt file and specify it as the
      # entrypoint of the mozc_buildenv container.
      sudo docker run --rm -v $MOZC_BUILDENV_OUTPUT_BINARY:/build.sh \
        --entrypoint=/build.sh mozc_buildenv >$HOME/bin/mozc_emacs_helper
      chmod +x $HOME/bin/mozc_emacs_helper
    fi
    ;;
  debian)
    # use backports
    if [ ! -f /etc/apt/sources.list.d/backports.list ]
    then
      curl -fsSL $SETUP_BASEURL/scripts/apt.debian.sh | sh
    fi
    if ! which git >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/git.sh | sh
    fi
    sudo apt-get install -y --no-install-recommends emacs
    sudo apt-get install -y --no-install-recommends clangd
    sudo apt-get install -y --no-install-recommends aspell aspell-en ripgrep w3m
    ;;
  macos)
    if ! which -s brew
    then
      curl -fsSL $SETUP_BASEURL/scripts/homebrew.macos.sh | sh
    fi
    brew install --cask emacs
    brew install llvm
    brew install aspell ripgrep w3m
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

mkdir -p $HOME/bin

cat <<'EOF' >$HOME/bin/em
#!/bin/sh
emacsclient --alternate-editor='' -n $@
EOF
chmod +x $HOME/bin/em

cat <<'EOF' >$HOME/bin/kem
#!/bin/sh
emacsclient -e '(kill-emacs)'
EOF
chmod +x $HOME/bin/kem

mkdir -p $HOME/.emacs.d
curl -fsSL $SETUP_BASEURL/files/emacs.init.el >$HOME/.emacs.d/init.el
emacs --batch -l $HOME/.emacs.d/init.el  # installs packages

# tests
emacs --version
emacsclient --version
if [ "$SETUP_TARGET" = arch ]
then
  $HOME/bin/mozc_emacs_helper </dev/null
fi
if [ "$SETUP_TARGET" = debian ]
then
  clangd-11 --version
else
  clangd --version
fi
aspell --version
rg --version
w3m -version
test -f $HOME/bin/em
test -f $HOME/bin/kem
test -f $HOME/.emacs.d/init.el
test "$(emacs --batch -l $HOME/.emacs.d/init.el 2>&1 | tail -1)" = 'Loaded init.el successfully'
