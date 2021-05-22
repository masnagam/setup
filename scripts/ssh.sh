echo "Configuring SSH..."

if [ -z "$SETUP_DOT_SSH" ]
then
  echo "ERROR: SETUP_DOT_SSH is required"
  exit 1
fi

install_file_() {
  local PERM_=$1
  local FILE_=$2

  if [ -f "$SETUP_DOT_SSH/$FILE_" ]
  then
    cp "$SETUP_DOT_SSH/$FILE_" "$HOME/.ssh/$FILE_"
    chmod $PERM_ "$HOME/.ssh/$FILE_"
  else
    echo "WARN: File not found: $SETUP_DOT_SSH/$FILE_"
  fi
}

mkdir -p $HOME/.ssh
chmod 0700 $HOME/.ssh
install_file_ 0644 config
install_file_ 0644 hosts
install_file_ 0600 id_ed25519
install_file_ 0644 id_ed25519.pub

sudo apt-get install -y --no-install-recommends keychain
mkdir -p $HOME/.profile.d
# https://wiki.archlinux.org/index.php/SSH_keys#Keychain
cat <<'EOF' >$HOME/.profile.d/00-keychain.sh
eval $(keychain --eval --quiet id_ed25519)
EOF
