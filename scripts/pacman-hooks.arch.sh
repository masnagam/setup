if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing pacman hooks..."

sudo mkdir -p /etc/pacman.d/hooks

# https://wiki.archlinux.org/title/Systemd-boot#pacman_hook
cat <<EOF | sudo tee /etc/pacman.d/hooks/95-systemd-boot.hook
[Trigger]
Type = Package
Operation = Upgrade
Target = systemd

[Action]
Description = Gracefully upgrading systemd-boot...
When = PostTransaction
Exec = /usr/bin/systemctl restart systemd-boot-update.service
EOF
