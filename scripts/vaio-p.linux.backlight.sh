echo "Installing /etc/udev/rules.d/90-backlight.rules..."
cat <<'EOF' | sudo tee /etc/udev/rules.d/90-backlight.rules >/dev/null
ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
ACTION=="add", SUBSYSTEM=="backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
ACTION=="add", SUBSYSTEM=="leds", RUN+="/bin/chgrp video /sys/class/leds/%k/brightness"
ACTION=="add", SUBSYSTEM=="leds", RUN+="/bin/chmod g+w /sys/class/leds/%k/brightness"
EOF

echo "Installing $HOME/bin/brightness..."
mkdir -p $HOME/bin
curl -fsSL $SETUP_BASEURL/files/vaio-p.linux.brightness >$HOME/bin/brightness
chmod +x $HOME/bin/brightness
