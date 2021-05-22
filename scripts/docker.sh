echo "Installing docker..."

case $SETUP_TARGET in
  debian)
    if ! which docker >/dev/null
    then
      curl -sSL https://get.docker.com | sudo sh
      sudo usermod -aG docker $(whoami) || true
    fi
    curl -fsSL https://raw.githubusercontent.com/masnagam/sbc-scripts/main/get-docker-compose | \
      sh | sudo tar -x -C /usr/local/bin
    ;;
esac

# tests
sudo docker version
sudo docker-compose version
