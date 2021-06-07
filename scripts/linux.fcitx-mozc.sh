echo "Installing fcitx-mozc..."

case $SETUP_TARGET in
  debian)
    sudo apt-get install -y --no-install-recommends \
      dbus-x11 fcitx fcitx-config-gtk fcitx-frontend-gtk3 fcitx-mozc mozc-utils-gui \
      fcitx-ui-light iso-codes
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

mkdir -p $HOME/.config/fcitx/addon
mkdir -p $HOME/.config/fcitx/conf

cat <<'EOF' >$HOME/.config/fcitx/config
[Hotkey]
TriggerKey=CTRL_\
EOF

cat <<'EOF' >$HOME/.config/fcitx/profile
[Profile]
IMName=mozc
EnabledIMList=fcitx-keyboard-us:True,mozc:True
EOF

cat <<'EOF' >$HOME/.config/fcitx/addon/fcitx-light-ui.config
[Addon]
Enabled=True
EOF

cat <<'EOF' >$HOME/.config/fcitx/conf/fcitx-xim.config
[Xim]
UseOnTheSpotStyle=True
EOF

cat <<'EOF' >$HOME/.config/fcitx/conf/fcitx-light-ui.config
[LightUI]
Font=Sarasa Term J
FontLocale=en_US.UTF-8
UseTray=False
MainWindowHideMode=Hide
EOF

mkdir -p $HOME/.xinitrc.d
cat <<'EOF' >$HOME/.xinitrc.d/ime.sh
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS='@im=fcitx'
EOF

mkdir -p $HOME/.Xresources.d
cat <<'EOF' >$HOME/.Xresources.d/input-method
URxvt.perl-ext-common: xim-onthespot
URxvt.inputMethod: fcitx
URxvt.preeditType: OnTheSpot
EOF

# tests
fcitx --version
