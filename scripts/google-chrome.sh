echo "Installing Google Chrome..."

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm google-chrome
    ;;
  debian)
    export DEBIAN_FRONTEND=noninteractive
    DEB="$(mktemp).deb"
    trap "rm -f $DEB" EXIT
    curl -fsSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb >$DEB
    sudo apt-get install -y --no-install-recommends $DEB
    ;;
  macos)
    if ! which -s brew
    then
      curl -fsSL $SETUP_BASEURL/scripts/homebrew.macos.sh | sh
    fi
    brew install --cask google-chrome
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

# tests
if [ "$SETUP_TARGET" != macos ]
then
  google-chrome --version
fi
