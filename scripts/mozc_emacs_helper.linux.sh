if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

MOZC_EMACS_HELPER=$HOME/bin/mozc_emacs_helper
MOZC_BUILDENV_DOCKERFILE_URL='https://raw.githubusercontent.com/google/mozc/master/docker/ubuntu20.04/Dockerfile'

if [ -x $MOZC_EMACS_HELPER ]
then
  echo "WARN: Remove $MOZC_EMACS_HELPER if re-installation is needed"
  exit 0
fi

if ! which docker >/dev/null 2>&1
then
  curl -fsSL $SETUP_BASEURL/scripts/docker.sh | sh
fi

echo "Installing mozc_emacs_helper..."

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    MOZC_VERSION=$(paru -Si fcitx5-mozc | grep Version | \
                   cut -d ':' -f 2 | tr -d ' ' | sed 's/\(.*\)\..*/\1/')
    MOZC_BUILD_NUMBER=$(paru -Si fcitx5-mozc | grep Version | \
                        cut -d ':' -f 2 | cut -d '.' -f 3)
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

# mozc_emacs_helper is contained in emacs-mozc, but it conflicts with
# fcitx-mozc.  We build mozc_emacs_helper using docker as described in the
# following page:
# https://github.com/google/mozc/blob/master/docs/build_mozc_in_docker.md
curl -fsSL $MOZC_BUILDENV_DOCKERFILE_URL | \
  sudo docker build --rm -t mozc_buildenv -

BUILD_SH=$(mktemp)
trap "/bin/rm -f $BUILD_SH && sudo docker image rm mozc_buildenv" EXIT

cat <<'EOF' >$BUILD_SH
#!/bin/sh -eux
BUILD="$1"
COMMIT=$(git log --grep="$BUILD" --pretty=%H | tail -1)
git checkout -f --recurse-submodules $COMMIT
bazel build //unix/emacs:mozc_emacs_helper --config oss_linux -c opt
cat ./bazel-bin/unix/emacs/mozc_emacs_helper
EOF
chmod +x $BUILD_SH
mkdir -p $HOME/bin

# The following command doesn't work properly:
#
#   sudo docker run ... mozc_buildenv sh -c 'bazel build ...'
#
# As a workaround, we make a temporal scirpt file and specify it as the
# entrypoint of the mozc_buildenv container.
sudo docker run --rm -v $BUILD_SH:/build.sh \
   --entrypoint=/build.sh mozc_buildenv $MOZC_BUILD_NUMBER >$MOZC_EMACS_HELPER
chmod +x $MOZC_EMACS_HELPER

# tests
$MOZC_EMACS_HELPER </dev/null | grep $MOZC_VERSION
