echo "Installing vbox guest additions..."

if [ ! -e /dev/sr0 ]
then
  echo "ERROR: Insert VBoxGuestAdditions.iso before running this script"
  exit 1
fi

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm linux-headers make
    ;;
  debian)
    ARCH=$(uname -r | tr '-' '\n' | tail -1)
    sudo apt-get install -y --no-install-recommends linux-headers-$ARCH make
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

sudo mount /dev/sr0 /mnt
trap 'sudo umount /mnt' EXIT
sudo /mnt/VBoxLinuxAdditions.run

sudo gpasswd -a $(id -un) vboxsf || true

echo "INFO: reboot is needed"
