echo "Installing Nerd Fonts..."

FONT=Iosevka

case $SETUP_TARGET in
  arch)
    if ! which yay >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/yay.arch.sh | sh
    fi
    yay -S --noconfirm nerd-fonts-iosevka
    yay -S --noconfirm fontconfig
    ;;
  debian)
    sudo apt-get install -y --no-install-recommends fontconfig jq unzip
    mkdir -p $HOME/.local/share/fonts
    LATEST_URL=https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest
    DL_URL="$(curl -fsSL $LATEST_URL | jq -Mr '.assets[].browser_download_url' | grep $FONT)"
    ARCHIVE=$(mktemp)
    trap "rm -f $ARCHIVE" EXIT
    curl -fsSL "$DL_URL" >$ARCHIVE
    unzip -od $HOME/.local/share/fonts $ARCHIVE
    fc-cache -f
    ;;
  macos)
    if ! which -s brew
    then
      curl -fsSL $SETUP_BASEURL/scripts/homebrew.home.sh | sh
    fi
    brew install --cask font-iosevka-nerd-font
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

# tests
fc-list | grep $FONT >/dev/null
