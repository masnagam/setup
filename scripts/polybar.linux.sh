echo "Installing Polybar..."

case $SETUP_TARGET in
  arch)
    if ! which yay >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/yay.arch.sh | sh
    fi
    yay -S --noconfirm polybar
    yay -S --noconfirm psmisc  # killall
    ;;
  debian)
    # use backports
    if [ ! -f /etc/apt/sources.list.d/backports.list ]
    then
      curl -fsSL $SETUP_BASEURL/scripts/apt.debian.sh | sh
    fi
    sudo apt-get install -y --no-install-recommends -t buster-backports polybar
    sudo apt-get install -y --no-install-recommends psmisc  # killall
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

mkdir -p $HOME/.config/polybar
curl -fsSL $SETUP_BASEURL/files/polybar.linux.config >$HOME/.config/polybar/config
curl -fsSL $SETUP_BASEURL/files/polybar.linux.fcitx >$HOME/.config/polybar/fcitx
curl -fsSL $SETUP_BASEURL/files/polybar.linux.launch.sh >$HOME/.config/polybar/launch.sh

chmod +x $HOME/.config/polybar/fcitx

# tests
polybar --version