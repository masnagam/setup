if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing emacs..."

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
    paru -S --noconfirm emacs
    paru -S --noconfirm clang  # includes clangd
    paru -S --noconfirm aspell aspell-en ripgrep w3m
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

if [ -n "SETUP_DESKTOP" ]
then
  mkdir -p $HOME/.config/autostart
  cat <<'EOF' >$HOME/.config/autostart/emacs.desktop
[Desktop Entry]
Type=Application
Name=Emacs
Exec=emacs
EOF
fi

# tests
emacs --version
emacsclient --version
clangd --version
aspell --version
rg --version
w3m -version
test -f $HOME/bin/em
test -f $HOME/bin/kem
test -f $HOME/.emacs.d/init.el
test "$(emacs --batch -l $HOME/.emacs.d/init.el 2>&1 | tail -1)" = 'Loaded init.el successfully'
if [ -n "SETUP_DESKTOP" ]
then
  test -f $HOME/.config/autostart/emacs.desktop
fi
