if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing bash scripts..."

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm bash-completion direnv trash-cli
    ;;
  debian)
    sudo apt-get install -y --no-install-recommends bash-completion direnv trash-cli
    ;;
  macos)
    if ! which -s brew
    then
      curl -fsSL $SETUP_BASEURL/scripts/homebrew.macos.sh | sh
    fi
    brew install bash bash-completion@2 direnv trash
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

mkdir -p $HOME/.profile.d
mkdir -p $HOME/.bashrc.d
curl -fsSL $SETUP_BASEURL/files/bash.bash_profile >$HOME/.bash_profile
curl -fsSL $SETUP_BASEURL/files/bash.bashrc >$HOME/.bashrc

case $SETUP_TARGET in
  arch | debian)
    curl -fsSL $SETUP_BASEURL/files/bash.linux.aliases.sh >$HOME/.bashrc.d/aliases.sh
    ;;
  macos)
    curl -fsSL $SETUP_BASEURL/files/bash.macos.bash-completion.sh \
      >$HOME/.profile.d/bash-completion.sh
    curl -fsSL $SETUP_BASEURL/files/bash.macos.aliases.sh >$HOME/.bashrc.d/aliases.sh
    ;;
esac

# tests
bash -l -c 'echo $PATH | grep $HOME/bin >/dev/null'
