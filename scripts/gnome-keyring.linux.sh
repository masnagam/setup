if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing GNOME Keyring..."

PAM_LOGIN_CONFIG=/etc/pam.d/login
PAM_LOGIN_AUTH='auth       optional     pam_gnome_keyring.so'
PAM_LOGIN_SESSION='session    optional     pam_gnome_keyring.so auto_start'

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm gnome-keyring
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

# See https://wiki.archlinux.org/title/GNOME/Keyring#Using_the_keyring
if ! grep pam_gnome_keyring.so $PAM_LOGIN_CONFIG >/dev/null
then
  INSERT_AFTER=$(grep -n ^auth $PAM_LOGIN_CONFIG | tail -1 | cut -d ':' -f 1)
  sudo sed -i "${INSERT_AFTER}a$PAM_LOGIN_AUTH" $PAM_LOGIN_CONFIG
  INSERT_AFTER=$(grep -n ^session $PAM_LOGIN_CONFIG | tail -1 | cut -d ':' -f 1)
  sudo sed -i "${INSERT_AFTER}a$PAM_LOGIN_SESSION" $PAM_LOGIN_CONFIG
fi
cat $PAM_LOGIN_CONFIG

# Use keychain for SSH.
mkdir -p $HOME/.xinitrc.d
echo <<'EOF' >$HOME/.xinitrc.d/gnome-keyring.sh
eval $(gnome-keyring-daemon --start --components=secrets,pkcs11)
EOF

# tests
which gnome-keyring >/dev/null 2>&1
test $(grep "$PAM_LOGIN_AUTH" $PAM_LOGIN_CONFIG | wc -l) = 1
test $(grep "$PAM_LOGIN_SESSION" $PAM_LOGIN_CONFIG | wc -l) = 1
