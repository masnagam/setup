if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    echo "Installing packages..."
    # use pipewire in arch
    paru -S --noconfirm bluez bluez-utils pipewire-pulse
    # enable upower
    paru -S --noconfirm upower
    ;;
  debian)
    echo "Installing packages..."
    # use puseaudio in debian
    sudo apt-get install -y --no-install-recommends bluez pulseaudio-module-bluetooth
    # enable upower
    sudo apt-get install -u --no-install-recommends upower
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

echo "Enabling bluetooth service..."
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

echo "Enabling UPower service..."
sudo systemctl start upower
sudo systemctl enable upower

# tests
bluetoothctl --version
systemctl status bluetooth
systemctl status upower
