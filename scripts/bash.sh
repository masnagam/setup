echo "Installing bash scripts..."

case $SETUP_TARGET in
  debian)
    sudo apt-get install -y --no-install-recommends bash-completion direnv trash-cli
    ;;
  macos)
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
  debian)
    curl -fsSL $SETUP_BASEURL/files/linux.bash.aliases.sh >$HOME/.bashrc.d/aliases.sh
    ;;
  macos)
    curl -fsSL $SETUP_BASEURL/files/macos.bash.bash-completion.sh \
      >$HOME/.profile.d/bash-completion.sh
    curl -fsSL $SETUP_BASEURL/files/macos.bash.aliases.sh >$HOME/.bashrc.d/aliases.sh
    ;;
esac

# tests
bash -l -c 'echo $PATH | grep $HOME/bin >/dev/null'
