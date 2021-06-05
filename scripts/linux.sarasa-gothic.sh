echo "Installing Sarasa Gothic..."

case $SETUP_TARGET in
  debian)
    sudo apt-get install -y --no-install-recommends fontconfig jq p7zip
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

mkdir -p $HOME/.local/share/fonts

LATEST_URL=https://api.github.com/repos/be5invis/Sarasa-Gothic/releases/latest
DL_URL="$(curl -fsSL $LATEST_URL | jq -Mr '.assets[].browser_download_url' | grep ttc | head -1)"

ARCHIVE=$(mktemp)
trap "rm -f $ARCHIVE" EXIT

curl -fsSL "$DL_URL" >$ARCHIVE
7zr x -y -o$HOME/.local/share/fonts/ $ARCHIVE
fc-cache -f

# tests
fc-list | grep Sarasa >/dev/null
