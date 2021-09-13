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

mkdir -p $HOME/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm.git $HOME/.tmux/plugins/tpm

curl -fsSL $SETUP_BASEURL/files/tmux.conf >$HOME/.tmux.conf

# tests
tmux -V
