if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing fcitx5-mozc..."

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm fcitx5-mozc fcitx5-im
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

mkdir -p $HOME/.config/fcitx5/conf

curl -fsSL $SETUP_BASEURL/files/fcitx5.linux.config >$HOME/.config/fcitx5/config
curl -fsSL $SETUP_BASEURL/files/fcitx5.linux.profile >$HOME/.config/fcitx5/profile

cat <<'EOF' >$HOME/.config/fcitx5/conf/xim.conf
# Use On The Spot Style (Needs restarting)
UseOnTheSpot=True
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
fcitx5 --version
