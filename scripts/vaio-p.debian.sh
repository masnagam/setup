echo "Changing the console font..."
sudo sed -i 's/CODESET=.*/CODESET="lat15"/' /etc/default/console-setup
sudo sed -i 's/FONTFACE=.*/FONTFACE="Terminus"/' /etc/default/console-setup
sudo sed -i 's/FONTSIZE=.*/FONTSIZE="16x32"/' /etc/default/console-setup

echo "Disabling Caps Lock..."
sudo sed -i 's/XKBOPTIONS=.*/XKBOPTIONS="ctrl:nocaps"/' /etc/default/keyboard

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

echo "Customizing emacs for vaio-p..."
mkdir -p $HOME/.emacs.d
cat <<EOF >$HOME/.emacs.d/init-local.el
(add-to-list 'default-frame-alist '(font . "Sarasa Mono J-20"))
EOF

echo "Installing .Xresources.d/local..."
mkdir -p $HOME/.Xresources.d
cat <<EOF >$HOME/.Xresources.d/local
URxvt.font: xft:Sarasa Term J:size=20
URxvt.letterSpace: 0
EOF

echo 'Installing .Xmodmap...'
cat <<EOF >$HOME/.Xmodmap
remove mod1 = Alt_L
remove mod1 = Alt_R
remove mod4 = Super_L

keysym Alt_L = Super_L
keysym Super_L = Alt_L
keysym Alt_R = Super_R
keysym Menu = Alt_R

add mod1 = Alt_L
add mod1 = Alt_R
add mod4 = Super_L
add mod4 = Super_R
EOF

echo "Customizing i3 for vaio-p..."
mkdir -p $HOME/.config/i3
cat <<EOF >$HOME/.config/i3/11-font.config
font pango:Noto Sans Regular 16, FontAwesome 16
EOF