echo "Installing urxvt..."

case $SETUP_TARGET in
  arch)
    if ! which yay >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/yay.arch.sh | sh
    fi
    yay -S --noconfirm rxvt-unicode
    ;;
  debian)
    sudo apt-get install -y --no-install-recommends rxvt-unicode
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

mkdir -p $HOME/.Xresources.d
curl -fsSL $SETUP_BASEURL/files/urxvt.linux.Xresources >$HOME/.Xresources.d/urxvt

mkdir -p $HOME/.xinitrc.d
cat <<'EOF' >$HOME/.xinitrc.d/terminal.sh
# default terminal application
export TERMINAL=urxvt
# Override the TERM environment variable for avoiding issues in SSH sessions.
export TERM=xterm-256color
EOF

# tests
which urxvt >/dev/null
