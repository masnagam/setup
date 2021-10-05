echo "Installing i3..."

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm i3-gaps dex rofi
    paru -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
    paru -S --noconfirm alsa-utils pulseaudio pulseaudio-alsa
    ;;
  debian)
    sudo apt-get install -y --no-install-recommends i3-wm dex rofi
    sudo apt-get install -y --no-install-recommends \
      fonts-noto fonts-noto-mono fonts-noto-extra fonts-noto-unhinted \
      fonts-noto-cjk fonts-noto-cjk-extra fonts-noto-ui-core fonts-noto-ui-extra \
      fonts-noto-color-emoji
    sudo apt-get install -y --no-install-recommends alsa-utils pulseaudio
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

mkdir -p $HOME/.config/i3
curl -fsSL $SETUP_BASEURL/files/i3.linux.10-vars.config >$HOME/.config/i3/10-vars.config
curl -fsSL $SETUP_BASEURL/files/i3.linux.20-style.config >$HOME/.config/i3/20-style.config
curl -fsSL $SETUP_BASEURL/files/i3.linux.30-bindings.config >$HOME/.config/i3/30-bindings.config
curl -fsSL $SETUP_BASEURL/files/i3.linux.40-apps.config >$HOME/.config/i3/40-apps.config

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

# tests
i3 --version
dex --version
which rofi >/dev/null
fc-list | grep -i noto >/dev/null
