if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

cat <<'EOF' | sudo tee /etc/pacman.d/mirrorlist >/dev/null
Server = http://ftp.jaist.ac.jp/pub/Linux/ArchLinux/$repo/os/$arch
EOF
pacman -Syyu --noconfirm
pacman -S --noconfirm base-devel ca-certificates curl
