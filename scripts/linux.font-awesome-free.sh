echo "Installing Font Awesome Free..."

case $SETUP_TARGET in
  debian)
    sudo apt-get install -y --no-install-recommends fontconfig jq unzip
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

mkdir -p $HOME/.local/share/fonts

LATEST_URL=https://api.github.com/repos/FortAwesome/Font-Awesome/releases/latest
DL_URL="$(curl -fsSL $LATEST_URL | jq -Mr '.assets[].browser_download_url' | grep desktop)"

ARCHIVE=$(mktemp)
trap "rm -f $ARCHIVE" EXIT

curl -fsSL "$DL_URL" >$ARCHIVE
unzip -o $ARCHIVE 'fontawesome-free-5.15.3-desktop/otfs/*' -d $HOME/.local/share/fonts
fc-cache -f

# tests
fc-list | grep 'Font Awesome' >/dev/null
