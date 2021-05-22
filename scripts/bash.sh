echo "Installing bash scripts..."

sudo apt-get install -y --no-install-recommends bash-completion direnv trash-cli
mkdir -p $HOME/.profile.d
mkdir -p $HOME/.bashrc.d
curl -fsSL $SETUP_BASEURL/files/bash.bash_profile >$HOME/.bash_profile
curl -fsSL $SETUP_BASEURL/files/bash.bashrc >$HOME/.bashrc
curl -fsSL $SETUP_BASEURL/files/linux.bash.aliases.sh >$HOME/.bashrc.d/aliases.sh

# tests
bash -l -c 'echo $PATH | grep $HOME/bin >/dev/null'
