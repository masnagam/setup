# See https://github.com/jguer/yay#source

if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing yay..."

sudo pacman -S --needed --noconfirm git base-devel

SRC=$(mktemp -d)
trap "rm -rf $SRC" EXIT
git clone https://aur.archlinux.org/yay.git $SRC
(cd $SRC; makepkg -si --noconfirm)
