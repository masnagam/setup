echo "Installing Google Chrome..."

case $SETUP_TARGET in
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
      curl -fsSL $SETUP_BASEURL/scripts/macos.homebrew.sh | sh
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
