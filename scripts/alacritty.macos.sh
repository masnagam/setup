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
  tic -xe alacritty,alacritty-direct $HOME/.config/alacritty/terminfo
then

# tests
alacritty --version
