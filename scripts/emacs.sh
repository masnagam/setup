echo "Installing emacs..."

case $SETUP_TARGET in
  debian)
    # use backports
    if [ ! -f /etc/apt/sources.list.d/backports.list ]
    then
      curl -fsSL $SETUP_BASEURL/scripts/debian.apt.sh | sh
    fi
    sudo apt-get install -y --no-install-recommends -t buster-backports emacs
    sudo apt-get install -y --no-install-recommends aspell aspell-en ripgrep
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
rg --version
aspell --version
apt list --installed 2>/dev/null | grep emacs/ | grep backports
test -f $HOME/bin/em
test -f $HOME/bin/kem
test -f $HOME/.emacs.d/init.el
