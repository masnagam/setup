echo "Installing Sarasa Gothic..."

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm ttf-sarasa-gothic
    paru -S --noconfirm fontconfig
    ;;
  debian)
    sudo apt-get install -y --no-install-recommends fontconfig jq unzip
    mkdir -p $HOME/.local/share/fonts
    LATEST_URL=https://api.github.com/repos/be5invis/Sarasa-Gothic/releases/latest
    if [ -n "$SETUP_GITHUB_TOKEN" ]
    then
      GITHUB_API_AUTH_HEADER="Authorization: token $SETUP_GITHUB_TOKEN"
    else
      GITHUB_API_AUTH_HEADER=
    fi
    DL_URL=$(curl $LATEST_URL -fSL -H "$GITHUB_API_AUTH_HEADER" | \
               jq -Mr '.assets[].browser_download_url' | \
               grep -i sarasa-ttc- | \
               grep -i zip | \
               grep -i -v unhinted | \
               head -1)
    ARCHIVE=$(mktemp)
    trap "rm -f $ARCHIVE" EXIT
    curl -fsSL "$DL_URL" >$ARCHIVE
    unzip -o $ARCHIVE -d $HOME/.local/share/fonts/
    fc-cache -f
    ;;
  macos)
    if ! which -s brew
    then
      curl -fsSL $SETUP_BASEURL/scripts/macos.homebrew.sh | sh
    fi
    brew tap homebrew/cask-fonts
    brew install --cask font-sarasa-gothic
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

# tests
fc-list | grep Sarasa >/dev/null
