if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Customizing console-setup..."
sudo sed -i 's/CODESET=.*/CODESET="Lat15"/' /etc/default/console-setup
sudo sed -i 's/FONTFACE=.*/FONTFACE="Terminus"/' /etc/default/console-setup
sudo sed -i 's/FONTSIZE=.*/FONTSIZE="32x16"/' /etc/default/console-setup

echo "Customizing keyboard..."
sudo sed -i 's/XKBMODEL=.*/XKBMODEL="pc104"/' /etc/default/keyboard
sudo sed -i 's/XKBLAYOUT=.*/XKBLAYOUT="us"/' /etc/default/keyboard
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

echo "Customizing emacs..."
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

echo 'Remapping keys for X11...'
cat <<EOF >$HOME/.Xmodmap
clear Mod1
clear Mod4

! left windows key
keycode 133 = Alt_L
! left alt key
keycode 64 = Super_L
! right alt key
keycode 108 = Super_R
! menu key
keycode 135 = Alt_R

add Mod1 = Alt_L Alt_R
add Mod4 = Super_L Super_R
EOF

echo "Customizing i3..."
mkdir -p $HOME/.config/i3
cat <<'EOF' >$HOME/.config/i3/11-vaio-p.config
set $font Noto Sans Regular, Font Awesome 6 Free Solid 16
EOF

echo "Customizing polybar..."
mkdir -p $HOME/.config/polybar
cat <<EOF >$HOME/.config/polybar/variables
font-noto = "Noto Sans Mono:pixelsize=16"
font-awesome-free = "Font Awesome 6 Free Solid:pixelsize=16"
font-awesome-brands = "Font Awesome 6 Brands Regular:pixelsize=16"
modules-left = i3
modules-center =
modules-right = cpu ram disk wifi battery fcitx5 date
EOF

echo "Hide cursor..."
sed -i 's|exec startx$|exec startx -- -nocursor|' $HOME/.bash_profile

# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=966218
# https://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg1944635.html
echo 'Workaround for "iwlwifi firmware: failed to load iwl-debug-yoyo.bin (-2)"...'
cat <<'EOF' | sudo tee /etc/modprobe.d/iwlwifi.conf >/dev/null
options iwlwifi enable_ini=0
EOF
