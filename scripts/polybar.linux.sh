if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing Polybar..."

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm polybar
    paru -S --noconfirm psmisc  # killall
    ;;
  debian)
    # use backports
    if [ ! -f /etc/apt/sources.list.d/backports.list ]
    then
      curl -fsSL $SETUP_BASEURL/scripts/apt.debian.sh | sh
    fi
    sudo apt-get install -y --no-install-recommends polybar
    sudo apt-get install -y --no-install-recommends psmisc  # killall
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

mkdir -p $HOME/.config/polybar
curl -fsSL $SETUP_BASEURL/files/polybar.linux.bluetooth >$HOME/.config/polybar/bluetooth
curl -fsSL $SETUP_BASEURL/files/polybar.linux.fcitx >$HOME/.config/polybar/fcitx
curl -fsSL $SETUP_BASEURL/files/polybar.linux.fcitx5 >$HOME/.config/polybar/fcitx5
curl -fsSL $SETUP_BASEURL/files/polybar.linux.launch.sh >$HOME/.config/polybar/launch.sh
curl -fsSL $SETUP_BASEURL/files/polybar.linux.config >$HOME/.config/polybar/config.ini
curl -fsSL $SETUP_BASEURL/files/polybar.linux.variables >$HOME/.config/polybar/variables

chmod +x $HOME/.config/polybar/bluetooth
chmod +x $HOME/.config/polybar/fcitx
chmod +x $HOME/.config/polybar/fcitx5

# tests
polybar --version
