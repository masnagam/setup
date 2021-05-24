echo "Configuring APT..."

# TODO: Should use https instead of http?

# add contrib and non-free
sudo sed -i 's/^\(deb .*\) main$/\1 main contrib non-free/' /etc/apt/sources.list
sudo sed -i 's/^\(deb-src .*\) main$/\1 main contrib non-free/' /etc/apt/sources.list

# use backports
cat <<'EOF' > sudo tee /etc/apt/sources.list.d/backports.list
deb http://deb.debian.org/debian buster-backports main contrib non-free
EOF

sudo apt-get update
