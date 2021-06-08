echo "Installing tmux..."

case $SETUP_TARGET in
  debian)
    sudo apt-get install -y --no-install-recommends git tmux
    ;;
  macos)
    if ! which -s brew
    then
      curl -fsSL $SETUP_BASEURL/scripts/macos.homebrew.sh | sh
    fi
    brew install tmux
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

mkdir -p $HOME/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm.git $HOME/.tmux/plugins/tpm

curl -fsSL $SETUP_BASEURL/files/tmux.conf >$HOME/.tmux.conf

# tests
tmux -V
