echo "Installing X11..."

case $SETUP_TARGET in
  debian)
    sudo apt-get install -y --no-install-recommends rxvt-unicode xorg xsel
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

mkdir -p $HOME/.xinitrc.d
mkdir -p $HOME/.Xresources.d

curl -fsSL $SETUP_BASEURL/files/linux.xinitrc >$HOME/.xinitrc
curl -fsSL $SETUP_BASEURL/files/linux.Xresources >$HOME/.Xresources

# tests
which xsel >/dev/null
which startx >/dev/null
which xinit >/dev/null
