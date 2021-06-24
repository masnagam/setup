echo "Installing Polybar..."

case $SETUP_TARGET in
  debian)
    # use backports
    if [ ! -f /etc/apt/sources.list.d/backports.list ]
    then
      curl -fsSL $SETUP_BASEURL/scripts/debian.apt.sh | sh
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
curl -fsSL $SETUP_BASEURL/files/linux.polybar.config >$HOME/.config/polybar/config
curl -fsSL $SETUP_BASEURL/files/linux.polybar.fcitx >$HOME/.config/polybar/fcitx
curl -fsSL $SETUP_BASEURL/files/linux.polybar.launch.sh >$HOME/.config/polybar/launch.sh

chmod +x $HOME/.config/polybar/fcitx

# tests
polybar --version
