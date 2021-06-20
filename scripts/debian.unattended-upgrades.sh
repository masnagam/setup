echo "Installing unattended upgrades..."

if [ -z "$SETUP_EMAIL" ]
then
  echo "ERROR: SETUP_EMAIL is required"
  exit 1
fi

sudo apt-get install -y --no-install-recommends apt-listchanges unattended-upgrades

curl -fsSL $SETUP_BASEURL/files/debian.apt.listchanges.conf | \
  sed "s|{{SETUP_EMAIL}}|$SETUP_EMAIL|g" | \
  sudo tee /etc/apt/listchanges.conf >/dev/null

curl -fsSL $SETUP_BASEURL/files/debian.atp.auto-update | \
  sed "s|{{SETUP_EMAIL}}|$SETUP_EMAIL|g" | \
  sudo tee /etc/apt/apt.conf.d/99-auto-update >/dev/null

cat <<EOF
Change update/upgrade schedules by running the following commands:

* sudo systemctl edit apt-daily.timer
* sudo systemctl edit apt-daily-upgrade.timer

Default schedules are like below:
----- /usr/lib/systemd/system/apt-daily.timer
$(cat /usr/lib/systemd/system/apt-daily.timer)

----- /usr/lib/systemd/system/apt-daily-upgrade.timer
$(cat /usr/lib/systemd/system/apt-daily-upgrade.timer)

EOF
