echo "Installing .Xresources.d/local..."
mkdir -p $HOME/.Xresources.d
cat <<EOF >$HOME/.Xresources.d/local
URxvt.font: xft:Sarasa Term J:size=20
URxvt.letterSpace: 0
EOF

echo 'Installing .Xmodmap...'
cat <<EOF >$HOME/.Xmodmap
remove mod1 = Alt_L
remove mod1 = Alt_R
remove mod4 = Super_L

keysym Alt_L = Super_L
keysym Super_L = Alt_L
keysym Alt_R = Super_R
keysym Menu = Alt_R

add mod1 = Alt_L
add mod1 = Alt_R
add mod4 = Super_L
add mod4 = Super_R
EOF
