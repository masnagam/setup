NTP=ntp.nict.jp

echo "Uninstalling chrony..."
sudo apt-get purge -y chrony

echo "Enabling systemd-timesyncd..."
sudo sed -i -e "s/^#NTP=/NTP=$NTP/" /etc/systemd/timesyncd.conf
sudo systemctl restart systemd-timesyncd
sudo systemctl enable systemd-timesyncd

# test
! dpkg -l | grep chrony
! systemctl status chronyd >/dev/null
test "$(cat /etc/systemd/timesyncd.conf | grep -e '^NTP=' | cut -d '=' -f 2)" = "$NTP"
systemctl status systemd-timesyncd | grep $NTP >/dev/null
