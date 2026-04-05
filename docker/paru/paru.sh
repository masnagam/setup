set -eu

pacman -Sy --noconfirm base-devel git rust sudo

useradd -m paru
echo "paru ALL=(ALL) NOPASSWD: ALL" >/etc/sudoers.d/paru

git clone https://aur.archlinux.org/paru.git
chown -R paru paru
(cd paru; su paru -s /bin/bash -c "makepkg -si --noconfirm")
rm -fr paru

test -e /usr/bin/paru
paru --version
