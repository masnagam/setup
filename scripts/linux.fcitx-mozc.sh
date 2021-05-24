echo "Installing fcitx-mozc..."

case $SETUP_TARGET in
  debian)
    sudo apt-get install -y --no-install-recommends fcitx fcitx-config-gtk fcitx-mozc
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

# TODO: change settings in $HOME/.config/fcitx/config (or $XDG_CONFIG_HOME/fcitx/config).

mkdir -p $HOME/.xinitrc.d
cat <<'EOF' >$HOME/.xinitrc.d/ime.sh
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS='@im=fcitx'
EOF
chmod +x $HOME/.xinitrc.d/ime.sh

# tests
fcitx --version
