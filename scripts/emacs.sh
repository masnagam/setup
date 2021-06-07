echo "Installing emacs..."

case $SETUP_TARGET in
  debian)
    # use backports
    if [ ! -f /etc/apt/sources.list.d/backports.list ]
    then
      curl -fsSL $SETUP_BASEURL/scripts/debian.apt.sh | sh
    fi
    sudo apt-get install -y --no-install-recommends -t buster-backports emacs clangd-11
    sudo apt-get install -y --no-install-recommends \
      aspell aspell-en ripgrep w3m emacs-mozc-bin
    ;;
  macos)
    if ! which -s brew
    then
      curl -fsSL $SETUP_BASEURL/scripts/macos.homebrew.sh | sh
    fi
    brew install --cask emacs font-fontawesome font-sarasa-gothic font-material-icons
    brew install aspell ripgrep w3m
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
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
clangd-11 --version
aspell --version
rg --version
w3m -version
mozc_emacs_helper </dev/null
test -f $HOME/bin/em
test -f $HOME/bin/kem
test -f $HOME/.emacs.d/init.el
