if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Configuring SSH..."

mkdir -p $HOME/.ssh
chmod 0700 $HOME/.ssh

cat <<EOF >$HOME/.ssh/config
Include hosts
Host *
  AddKeysToAgent yes
EOF
if [ "$SETUP_TARGET" = macos ]
then
  # https://developer.apple.com/library/archive/technotes/tn2449/_index.html
  echo '  UseKeychain yes' >>$HOME/.ssh/config
fi

if [ -n "$SETUP_DOT_SSH" ]
then
  cp -R $SETUP_DOT_SSH/* $HOME/.ssh/
  chmod 0600 $HOME/.ssh/id_*
  chmod 0644 $HOME/.ssh/id_*.pub
fi

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm keychain openssh
    ;;
  debian)
    sudo apt-get install -y --no-install-recommends keychain
    ;;
esac

if [ "$SETUP_TARGET" = arch ] || [ "$SETUP_TARGET" = debian ]
then
  mkdir -p $HOME/.profile.d
  # https://wiki.archlinux.org/index.php/SSH_keys#Keychain
  cat <<'EOF' >$HOME/.profile.d/00-keychain.sh
# Password input will be prompted once accessing to each private key.
eval $(keychain --eval --quiet)
EOF
fi

# tests
/bin/ls -la $HOME | grep -e "^drwx------.*$(id -un).*$(id -gn).*\.ssh$" >/dev/null
/bin/ls -l $HOME/.ssh/config | grep -e "^-rw-r--r--.*$(id -un).*$(id -gn).*config$" >/dev/null
/bin/ls -l $HOME/.ssh/id_ed25519 | grep -e "^-rw-------.*$(id -un).*$(id -gn).*id_ed25519$" >/dev/null
/bin/ls -l $HOME/.ssh/id_ed25519.pub | grep -e "^-rw-r--r--.*$(id -un).*$(id -gn).*id_ed25519.pub$" >/dev/null
