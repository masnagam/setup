echo "Installing .dir_colors..."
curl -fsSL https://github.com/arcticicestudio/nord-dircolors/blob/develop/src/dir_colors \
  >$HOME/.dir_colors

echo "Installing .Xresources.d/color-theme..."
mkdir -p $HOME/.Xresources.d
curl -fsSL https://raw.githubusercontent.com/arcticicestudio/nord-xresources/develop/src/nord \
  >$HOME/.Xresources.d/color-theme
