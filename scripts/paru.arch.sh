if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing paru..."

if ! which git >/dev/null 2>&1
then
  sudo pacman -S --noconfirm git
fi

SRC=$(mktemp -d)
trap "rm -rf $SRC" EXIT
git clone https://aur.archlinux.org/paru.git $SRC
(cd $SRC; makepkg -si -r --noconfirm)  # -r: remove makedepends

# tests
paru -V
test "$(which cargo)" != /usr/bin/cargo
