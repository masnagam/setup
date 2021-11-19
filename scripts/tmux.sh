if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing tmux..."

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm tmux git
    ;;
  debian)
    sudo apt-get install -y --no-install-recommends tmux git
    ;;
  macos)
    if ! which -s brew
    then
      curl -fsSL $SETUP_BASEURL/scripts/homebrew.macos.sh | sh
    fi
    brew install tmux git
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

if [ ! -e $HOME/.tmux/plugins/tpm ]
then
  echo "Installing tpm..."
  mkdir -p $HOME/.tmux/plugins
  git clone https://github.com/tmux-plugins/tpm.git $HOME/.tmux/plugins/tpm
fi

curl -fsSL $SETUP_BASEURL/files/tmux.conf >$HOME/.tmux.conf
bash $HOME/.tmux/plugins/tpm/scripts/install_plugins.sh

# tests
tmux -V
