if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing SSH server..."

SSHD_SERVICE=ssh

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm openssh
    SSHD_SERVICE=sshd
    ;;
  debian)
    sudo apt-get install -y --no-install-recommends openssh-server
    # See: https://serverfault.com/questions/706475/ssh-sessions-hang-on-shutdown-reboot
    sudo apt-get install -y --no-install-recommends dbus libpam-systemd
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

sudo sed -i -e 's|^#*PermitRootLogin\s\+.*|PermitRootLogin no|ig' /etc/ssh/sshd_config

sudo systemctl restart $SSHD_SERVICE
sudo systemctl enable $SSHD_SERVICE

# tests
systemctl status $SSHD_SERVICE >/dev/null
test "$(sudo sshd -T | sed -n 's|^PermitRootLogin\s\+||ip')" = "no"
