echo "Installing docker..."

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm docker docker-compose polkit
    sudo groupmems -g docker -a $(whoami) || true
    sudo systemctl start docker
    sudo systemctl enable docker
    ;;
  debian)
    case $(arch) in
      i386 | i686)
        echo "WARN: get.docker.com doesn't support $arch, install an older version by using apt"
        sudo apt-get install -y --no-install-recommends docker.io docker-compose
        ;;
      x86_64 | armv7l | aarch64)
        if ! which docker >/dev/null
        then
          curl -sSL https://get.docker.com | sudo sh
        fi
        curl -fsSL https://raw.githubusercontent.com/masnagam/sbc-scripts/main/get-docker-compose | \
          sh | sudo tar -x -C /usr/local/bin
        ;;
    esac
    sudo usermod -aG docker $(whoami) || true
    ;;
  macos)
    if ! which -s brew
    then
      curl -fsSL $SETUP_BASEURL/scripts/homebrew.macos.sh | sh
    fi
    brew install --cask docker
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

# tests
if [ "$SETUP_TARGET" != macos ]
then
  sudo docker version
  sudo docker-compose version
fi
