echo "Installing SSH server..."

case $SETUP_TARGET in
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

sudo systemctl restart ssh

# tests
systemctl status ssh >/dev/null
test "$(sudo sshd -T | sed -n 's|^PermitRootLogin\s\+||ip')" = "no"
