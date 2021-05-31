BASEURL=https://raw.githubusercontent.com/arcticicestudio
echo "Installing .dir_colors..."
curl -fsSL $BASEURL/nord-dircolors/develop/src/dir_colors >$HOME/.dir_colors

echo "Installing .Xresources.d/color-theme..."
mkdir -p $HOME/.Xresources.d
curl -fsSL $BASEURL/nord-xresources/develop/src/nord >$HOME/.Xresources.d/color-theme

# tests
cat $HOME/.dir_colors | head -1 | grep 'Arctic Ice Studio' >/dev/null
cat $HOME/.Xresources.d/color-theme | head -1 | grep 'Arctic Ice Studio' >/dev/null
