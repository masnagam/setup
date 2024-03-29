if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing Alacritty..."

if ! which -s brew
then
  curl -fsSL $SETUP_BASEURL/scripts/homebrew.macos.sh | sh
fi

brew install alacritty

mkdir -p $HOME/.config/alacritty
curl -fsSL https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info \
  >$HOME/.config/alacritty/terminfo
if ! infocmp alacritty >/dev/null
then
  tic -xe alacritty,alacritty-direct $HOME/.config/alacritty/terminfo
fi

# tests
alacritty --version
