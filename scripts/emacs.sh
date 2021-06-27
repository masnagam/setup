echo "Installing emacs..."

case $SETUP_TARGET in
  arch)
    if ! which yay >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/yay.arch.sh | sh
    fi
    yay -S --noconfirm emacs
    yay -S --noconfirm clang  # clangd
    yay -S --noconfirm aspell aspell-en ripgrep w3m
    ;;
  debian)
    # use backports
    if [ ! -f /etc/apt/sources.list.d/backports.list ]
    then
      curl -fsSL $SETUP_BASEURL/scripts/debian.apt.sh | sh
    fi
    sudo apt-get install -y --no-install-recommends -t buster-backports emacs
    sudo apt-get install -y --no-install-recommends -t buster-backports clangd-11
    sudo apt-get install -y --no-install-recommends aspell aspell-en ripgrep w3m
    ;;
  macos)
    if ! which -s brew
    then
      curl -fsSL $SETUP_BASEURL/scripts/macos.homebrew.sh | sh
    fi
    brew install --cask emacs
    brew install llvm
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
if [ "$SETUP_TARGET" = debian ]
then
  clangd-11 --version
else
  clangd --version
fi
aspell --version
rg --version
w3m -version
test -f $HOME/bin/em
test -f $HOME/bin/kem
test -f $HOME/.emacs.d/init.el
