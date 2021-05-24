echo "Installing X11..."

case $SETUP_TARGET in
  debian)
    sudo apt-get install -y --no-install-recommends rxvt-unicode xorg xsel
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

mkdir -p $HOME/.xinitrc.d
mkdir -p $HOME/.Xresources.d

curl -fsSL $SETUP_BASEURL/files/linux.xinitrc >$HOME/.xinitrc
curl -fsSL $SETUP_BASEURL/files/linux.Xresources >$HOME/.Xresources
curl -fsSL $SETUP_BASEURL/files/linux.Xresources.urxvt >$HOME/.Xresources.d/urxvt

cat <<'EOF' >$HOME/.xinitrc.d/terminal.sh
# default terminal application
export TERMINAL=urxvt
# Override the TERM environment variable for avoiding issues in SSH sessions.
export TERM=xterm-256color
EOF
chmod +x $HOME/.xinitrc.d/terminal.sh

# tests
which urxvt >/dev/null
which xsel >/dev/null
which startx >/dev/null
which xinit >/dev/null
