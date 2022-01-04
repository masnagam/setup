if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing paru..."

if ! which git >/dev/null 2>&1
then
  sudo pacman -S --noconfirm git
fi

PKG=$(mktemp -d)
trap "rm -rf $PKG" EXIT
git clone --depth=1 https://aur.archlinux.org/paru-bin.git $PKG
(cd $PKG; makepkg -si --noconfirm)

# tests
paru -V
