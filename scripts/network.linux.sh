if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

if [ -z "$SETUP_NET_IF" ]
then
  echo "ERROR: SETUP_NET_IF is required"
  exit 1
fi

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    echo "Installing packages..."
    paru -S --noconfirm avahi nss-mdns
    if ! grep mdns_minimal /etc/nsswitch.conf >/dev/null
    then
      sudo sed -i -e 's|resolve|mdns_minimal \[NOTFOUND=return\] resolve|' \
        /etc/nsswitch.conf
    fi
    ;;
  debian)
    echo "Installing packages..."
    sudo apt-get install -y --no-install-recommends avahi-daemon libnss-mdns
    echo "Purge network-manager..."
    sudo apt-get purge -y network-manager
    sudo rm -rf /etc/NetworkManager
    echo "Modifying /etc/network/interfaces..."
    sudo sed -i -e "s|^.*$SETUP_NET_IF.*$|#\0|" /etc/network/interfaces
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

echo "Installing /etc/systemd/network/wired.network..."
cat <<EOF | sudo tee /etc/systemd/network/wired.network >/dev/null
[Match]
Name=$SETUP_NET_IF

[Network]
DHCP=yes

[DHCP]
UseDomains=true
EOF

echo "Enabling systemd-networkd..."
sudo systemctl start systemd-networkd
sudo systemctl enable systemd-networkd

echo "Enabling systemd-resolved..."
sudo systemctl start systemd-resolved
sudo systemctl enable systemd-resolved
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

echo "Enabling mDNS..."
sudo systemctl start avahi-daemon
sudo systemctl enable avahi-daemon

# tests
if [ "$SETUP_TARGET" = debian ]
then
  ! dpkg -l | grep network-manager
fi
test "$(cat /etc/systemd/network/wired.network | grep -e '^Name=' | cut -d '=' -f 2)" = "$SETUP_NET_IF"
systemctl status systemd-networkd >/dev/null
systemctl status systemd-resolved >/dev/null
systemctl status avahi-daemon >/dev/null
