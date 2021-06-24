echo "Disabling IPv6 (GRUB)..."

sudo sed -i -e 's|^GRUB_CMDLINE_LINUX=.*|GRUB_CMDLINE_LINUX="ipv6.disable=1"|' /etc/default/grub
sudo update-grub

# tests
grep 'GRUB_CMDLINE_LINUX=' | grep 'ipv6.disable=1' >/dev/null
