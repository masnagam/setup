if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

cat <<'EOF' | sudo tee /etc/pacman.d/mirrorlist >/dev/null
Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch
EOF
# DO NOT upgrade `linux`.
# This may replace the kernel modules and require reboot.
pacman -Sy --noconfirm base-devel ca-certificates curl
