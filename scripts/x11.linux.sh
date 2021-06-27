echo "Installing X11..."

case $SETUP_TARGET in
  arch)
    if ! which yay >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/yay.arch.sh | sh
    fi
    yay -S --noconfirm xorg-server xorg-xdpyinfo xorg-xinit xorg-xprop xorg-xev xsel
    ;;
  debian)
    sudo apt-get install -y --no-install-recommends xorg xsel
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

mkdir -p $HOME/.xinitrc.d
mkdir -p $HOME/.Xresources.d

curl -fsSL $SETUP_BASEURL/files/x11.linux.xinitrc >$HOME/.xinitrc
curl -fsSL $SETUP_BASEURL/files/x11.linux.Xresources >$HOME/.Xresources

# tests
which xsel >/dev/null
which startx >/dev/null
which xinit >/dev/null
