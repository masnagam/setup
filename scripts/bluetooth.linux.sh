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
    ;;
  debian)
    echo "Installing packages..."
    # use puseaudio in debian
    sudo apt-get install -y --no-install-recommends bluez pulseaudio-module-bluetooth
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

echo "Enabling bluetooth service..."
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

# tests
bluetoothctl --version
