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
    paru -S --noconfirm docker docker-buildx docker-compose polkit
    sudo usermod -aG docker $(whoami)
    sudo systemctl start docker
    sudo systemctl enable docker
    ;;
  debian)
    case $(arch) in
      i386 | i686)
        echo "WARN: get.docker.com doesn't support $arch, install an older version by using apt"
        sudo apt-get install -y --no-install-recommends apparmor docker.io docker-compose
        ;;
      x86_64 | armv7* | aarch64)
        # get-docker.sh doesn't install docker-compose plug-in if an old one
        # exists in /usr/local/lib/docker/cli-plugins.
        sudo rm -rf /usr/local/lib/docker
        # apparmor is required in order to avoid errors.
        # See https://github.com/moby/moby/issues/25488.
        sudo apt-get install -y --no-install-recommends apparmor jq
        if ! which docker >/dev/null || ! docker compose version >/dev/null || ! docker buildx version >/dev/null
        then
          # get-docker.sh will install docker-compose and docker-buildx plug-ins.
          curl -sSL https://get.docker.com | sudo sh
        fi
        ARCH=$(arch)
        if [ "$ARCH" = armv7l ]
        then
          ARCH=armv7
        fi
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

# https://stackoverflow.com/questions/20828657/docker-change-ctrlp-to-something-else
mkdir -p $HOME/.docker
cat <<EOF >$HOME/.docker/config.json
{
  "detachKeys": "ctrl-z,z"
}
EOF

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
      sudo docker buildx version
      ;;
  esac
fi
