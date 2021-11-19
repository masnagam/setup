if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing Material design icons..."

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm ttf-material-design-icons
    paru -S --noconfirm fontconfig
    ;;
  debian)
    sudo apt-get install -y --no-install-recommends fontconfig jq unzip
    mkdir -p $HOME/.local/share/fonts
    DL_URL=https://github.com/google/material-design-icons/releases/download/3.0.1/material-design-icons-3.0.1.zip
    ARCHIVE=$(mktemp)
    trap "rm -f $ARCHIVE" EXIT
    curl -fsSL "$DL_URL" >$ARCHIVE
    unzip -o $ARCHIVE 'material-design-icons-3.0.1/iconfont/*' -d $HOME/.local/share/fonts/
    fc-cache -f
    ;;
  macos)
    if ! which -s brew
    then
      curl -fsSL $SETUP_BASEURL/scripts/homebrew.home.sh | sh
    fi
    brew tap homebrew/cask-fonts
    brew install --cask font-material-icons
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

# tests
fc-list | grep 'Material Icons' >/dev/null
