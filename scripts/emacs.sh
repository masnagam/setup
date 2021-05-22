echo "Installing emacs..."

case $SETUP_TARGET in
  debian)
    sudo apt-get install -y --no-install-recommends emacs ripgrep
    ;;
esac

mkdir -p $HOME/bin

cat <<'EOF' >$HOME/bin/em
#!/bin/sh
emacsclient --alternate-editor='' -n $@
EOF
chmod +x $HOME/bin/em

cat <<'EOF' >$HOME/bin/kem
#!/bin/sh
emacsclient -e '(kill-emacs)'
EOF
chmod +x $HOME/bin/kem

mkdir -p $HOME/.emacs.d
curl -fsSL $SETUP_BASEURL/files/emacs.init.el >$HOME/.emacs.d/init.el

# tests
emacs --version
emacsclient --version
test -f $HOME/bin/em
test -f $HOME/bin/kem
test -f $HOME/.emacs.d/init.el
