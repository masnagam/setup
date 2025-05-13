if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing reflector..."
sudo pacman -S --noconfirm reflector

echo "Creating /etc/xdg/reflector/reflector.conf..."
cat <<EOF | sudo tee /etc/xdg/reflector/reflector.conf
--save /etc/pacman.d/mirrorlist
--protocol https
--country Japan,
--age 12
--fastest 5
EOF

echo "Enabling reflector service..."
sudo systemctl start reflector
sudo systemctl enable reflector

# tests
sudo systemctl status reflector
