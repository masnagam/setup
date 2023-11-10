if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing i3..."

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm i3-wm dex rofi
    paru -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
    # use pipewire
    paru -S --noconfirm alsa-utils pipewire pipewire-pulse wireplumber
    ;;
  debian)
    sudo apt-get install -y --no-install-recommends i3-wm dex rofi
    sudo apt-get install -y --no-install-recommends \
      fonts-noto fonts-noto-mono fonts-noto-extra fonts-noto-unhinted \
      fonts-noto-cjk fonts-noto-cjk-extra fonts-noto-ui-core fonts-noto-ui-extra \
      fonts-noto-color-emoji
    # use pulseaudio
    sudo apt-get install -y --no-install-recommends alsa-utils pulseaudio pavucontrol
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

mkdir -p $HOME/.config/i3
curl -fsSL $SETUP_BASEURL/files/i3.linux.10-vars.config \
  >$HOME/.config/i3/10-vars.config
curl -fsSL $SETUP_BASEURL/files/i3.linux.20-style.config \
  >$HOME/.config/i3/20-style.config
curl -fsSL $SETUP_BASEURL/files/i3.linux.30-bindings.config \
  >$HOME/.config/i3/30-bindings.config
curl -fsSL $SETUP_BASEURL/files/i3.linux.40-screens.config \
  >$HOME/.config/i3/40-screens.config
curl -fsSL $SETUP_BASEURL/files/i3.linux.50-assignments.config \
  >$HOME/.config/i3/50-assignments.config
curl -fsSL $SETUP_BASEURL/files/i3.linux.90-postprocess.config \
  >$HOME/.config/i3/90-postprocess.config

cat <<'EOF' >$HOME/.config/i3/mkconfig
echo '# i3 config file (v4)' >$HOME/.config/i3/config
cat $HOME/.config/i3/*.config >>$HOME/.config/i3/config
EOF
chmod +x $HOME/.config/i3/mkconfig

mkdir -p $HOME/.xinitrc.d
cat <<'EOF' >$HOME/.xinitrc.d/exec-wm
$HOME/.config/i3/mkconfig
exec i3
EOF

mkdir -p $HOME/.config/autostart
cat <<'EOF' >$HOME/.config/autostart/terminal.desktop
[Desktop Entry]
Type=Application
Name=Terminal
Exec=i3-sensible-terminal -e tmux
EOF

# tests
i3 --version
dex --version
which rofi >/dev/null
fc-list | grep -i noto >/dev/null
test -f $HOME/.config/autostart/terminal.desktop
