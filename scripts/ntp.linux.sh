if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

NTP=ntp.nict.jp

case $SETUP_TARGET in
  arch)
    ;;
  debian)
    echo "Replacing chrony with systemd-timesyncd..."
    sudo apt-get purge -y chrony
    sudo apt-get install -y --no-install-recommends systemd-timesyncd
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

echo "Enabling systemd-timesyncd..."
sudo sed -i -e "s/^#NTP=/NTP=$NTP/" /etc/systemd/timesyncd.conf
sudo systemctl restart systemd-timesyncd
sudo systemctl enable systemd-timesyncd

# tests
if [ "$SETUP_TARGET" = debian ]
then
  ! dpkg -l | grep chrony
  ! systemctl status chronyd >/dev/null
fi
test "$(cat /etc/systemd/timesyncd.conf | grep -e '^NTP=' | cut -d '=' -f 2)" = "$NTP"
systemctl status systemd-timesyncd | grep $NTP >/dev/null
