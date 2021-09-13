echo "Installing paru..."

if ! which git >/dev/null 2>&1
then
  sudo pacman -S --noconfirm git
fi

if ! which fakeroot >/dev/null 2>&1
then
  sudo pacman -S --noconfirm fakeroot
fi

SRC=$(mktemp -d)
trap "rm -rf $SRC" EXIT
git clone https://aur.archlinux.org/paru.git $SRC
(cd $SRC; makepkg -si --noconfirm)

# tests
paru -h
