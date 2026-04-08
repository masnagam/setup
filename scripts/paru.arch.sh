if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

if ! which docker >/dev/null 2>&1
then
  curl -fsSL $SETUP_BASEURL/scripts/docker.sh | sh
fi

echo "Installing paru..."

mkdir -p $HOME/bin
sudo docker run --rm ghcr.io/masnagam/setup/paru cat /usr/bin/paru | sudo tee /usr/bin/paru >/dev/null
sudo chmod +x /usr/bin/paru

# Install required packages.
sudo pacman -S --noconfirm base-devel git sudo

# tests
test $(which paru) = /usr/bin/paru
paru --version
