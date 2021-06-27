echo "Configuring APT..."

VERSION=buster

# add contrib and non-free, use backports
# TODO: Should use https instead of http?
cat <<EOF | sudo tee /etc/apt/sources.list >/dev/null
deb http://deb.debian.org/debian $VERSION main contrib non-free
deb-src http://deb.debian.org/debian $VERSION main contrib non-free
deb http://security.debian.org/debian-security $VERSION/updates main contrib non-free
deb-src http://security.debian.org/debian-security $VERSION/updates main contrib non-free
deb http://deb.debian.org/debian $VERSION-updates main contrib non-free
deb-src http://deb.debian.org/debian $VERSION-updates main contrib non-free
EOF

cat <<EOF | sudo tee /etc/apt/sources.list.d/backports.list >/dev/null
deb http://deb.debian.org/debian $VERSION-backports main contrib non-free
deb-src http://deb.debian.org/debian $VERSION-backports main contrib non-free
EOF

cat <<EOF | sudo tee /etc/apt/apt.conf.d/99-no-install-recommends >/dev/null
APT::Install-Recommends "false";
APT::Install-Suggests "false";
EOF

sudo apt-get update

# tests
apt-config dump | grep 'APT::Install-Recommends "false";' >/dev/null
apt-config dump | grep 'APT::Install-Suggests "false";' >/dev/null