if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing docker..."

if [ -n "$SETUP_GITHUB_TOKEN" ]
then
  GITHUB_API_AUTH_HEADER="Authorization: token $SETUP_GITHUB_TOKEN"
else
  GITHUB_API_AUTH_HEADER=
fi

DOCKER_COMPOSE_LATEST_URL=https://api.github.com/repos/docker/compose/releases/latest

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm docker docker-compose polkit
    sudo usermod -aG docker $(whoami)
    sudo systemctl start docker
    sudo systemctl enable docker
    ;;
  debian)
    case $(arch) in
      i386 | i686)
        echo "WARN: get.docker.com doesn't support $arch, install an older version by using apt"
        sudo apt-get install -y --no-install-recommends docker.io docker-compose
        ;;
      x86_64 | armv7* | aarch64)
        sudo apt-get install -y --no-install-recommends jq
        if ! which docker >/dev/null
        then
          curl -sSL https://get.docker.com | sudo sh
        fi
        ARCH=$(arch)
        if [ "$ARCH" = armv7l ]
        then
          ARCH=armv7
        fi
        DL_URL=$(curl $DOCKER_COMPOSE_LATEST_URL -fsSL -H "$GITHUB_API_AUTH_HEADER" | jq -Mr '.assets[].browser_download_url' | grep -e docker-compose-linux-$ARCH\$)
        # Install to /usr/local/lib/docker/cli-plugins so that it works with sudo.
        sudo mkdir -p /usr/local/lib/docker/cli-plugins
        sudo curl $DL_URL -fsSL -o /usr/local/lib/docker/cli-plugins/docker-compose
        sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
        ;;
    esac
    sudo usermod -aG docker $(whoami)
    sudo systemctl start docker
    sudo systemctl enable docker
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
  case $(arch) in
    i386 | i686)
      sudo docker-compose version
      ;;
    *)
      sudo docker compose version
      ;;
  esac
fi
