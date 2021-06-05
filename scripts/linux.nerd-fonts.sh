echo "Installing Nerd Fonts..."

FONT=Iosevka

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

LATEST_URL=https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest
DL_URL="$(curl -fsSL $LATEST_URL | jq -Mr '.assets[].browser_download_url' | grep $FONT)"

ARCHIVE=$(mktemp)
trap "rm -f $ARCHIVE" EXIT

curl -fsSL "$DL_URL" >$ARCHIVE
unzip -od $HOME/.local/share/fonts $ARCHIVE
fc-cache -f

# tests
fc-list | grep $FONT >/dev/null
