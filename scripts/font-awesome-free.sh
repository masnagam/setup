echo "Installing Font Awesome Free..."

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm otf-font-awesome
    paru -S --noconfirm fontconfig
    ;;
  debian)
    sudo apt-get install -y --no-install-recommends fontconfig jq unzip
    mkdir -p $HOME/.local/share/fonts
    LATEST_URL=https://api.github.com/repos/FortAwesome/Font-Awesome/releases/latest
    if [ -n "$SETUP_GITHUB_TOKEN" ]
    then
      GITHUB_API_AUTH_HEADER="-H \"Authorization: token $SETUP_GITHUB_TOKEN\""
    else
      GITHUB_API_AUTH_HEADER=
    fi
    DL_URL="$(curl $GITHUB_API_AUTH_HEADER -fsSL $LATEST_URL | jq -Mr '.assets[].browser_download_url' | grep desktop)"
    ARCHIVE=$(mktemp)
    trap "rm -f $ARCHIVE" EXIT
    curl -fsSL "$DL_URL" >$ARCHIVE
    unzip -o $ARCHIVE 'fontawesome-free-*-desktop/otfs/*' -d $HOME/.local/share/fonts
    fc-cache -f
    ;;
  macos)
    if ! which -s brew
    then
      curl -fsSL $SETUP_BASEURL/scripts/homebrew.macos.sh | sh
    fi
    brew tap homebrew/cask-fonts
    brew install --cask font-fontawesome
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

# tests
fc-list | grep 'Font Awesome' >/dev/null
