BASEURL=https://raw.githubusercontent.com/nordtheme

echo "Installing .dir_colors..."
curl -fsSL $BASEURL/dircolors/develop/src/dir_colors >$HOME/.dir_colors

mkdir -p $HOME/.profile.d
cat <<'EOF' >$HOME/.profile.d/dircolors.sh
# https://github.com/nordtheme/dircolors#activation
test -r ~/.dir_colors && eval $(dircolors ~/.dir_colors)
EOF

echo "Installing .Xresources.d/color-theme..."
mkdir -p $HOME/.Xresources.d
curl -fsSL $BASEURL/xresources/develop/src/nord >$HOME/.Xresources.d/color-theme

# tests
cat $HOME/.dir_colors | grep 'FILE 00' >/dev/null
cat $HOME/.Xresources.d/color-theme | grep '#define nord0 #2E3440' >/dev/null
