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
    paru -S --noconfirm virtualbox virtualbox-host-modules-arch \
      virtualbox-guest-iso virtualbox-ext-oracle
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

sudo usermod -aG vboxusers $(whoami)

mkdir -p $HOME/.config/VirtualBox
echo <<EOF >$HOME/.config/VirtualBox/VirtualBox.xml
<?xml version="1.0"?>
<!--
** Missing properties will be filled with initial values once VirtualBox
** launches.  VirtualBox.xml will be overwritten when VirtualBox terminates.
-->
<VirtualBox xmlns="http://www.virtualbox.org/" version="1.12-linux">
  <Global>
    <SystemProperties defaultMachineFolder="$HOME/.vbox"/>
  </Global>
</VirtualBox>
EOF

# tests
#modprobe vboxdrv  # disabled in order to avoid a failure due to kernel version mismatch
vboxmanage --version
getent group vboxusers | grep $(whoami) >/dev/null
