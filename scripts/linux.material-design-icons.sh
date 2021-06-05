echo "Installing Material design icons..."

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

DL_URL=https://github.com/google/material-design-icons/releases/download/3.0.1/material-design-icons-3.0.1.zip

ARCHIVE=$(mktemp)
trap "rm -f $ARCHIVE" EXIT

curl -fsSL "$DL_URL" >$ARCHIVE
unzip -o $ARCHIVE 'material-design-icons-3.0.1/iconfont/*' -d $HOME/.local/share/fonts/
fc-cache -f

# tests
fc-list | grep 'Material Icons' >/dev/null
