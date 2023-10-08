if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

if [ -n "$SETUP_RPIOS" ]
then
  # Keep /etc/apt/sources.list.
  sudo apt-get update
  exit 0
fi

VERSION=$(cat /etc/os-release | grep VERSION_CODENAME | cut -d '=' -f 2)
echo "Configuring APT for $VERSION..."

COMPONENTS='main contrib non-free non-free-firmware'

# add contrib and non-free, use backports
# TODO: Should use https instead of http?
cat <<EOF | sudo tee /etc/apt/sources.list >/dev/null
deb http://deb.debian.org/debian $VERSION $COMPONENTS
deb-src http://deb.debian.org/debian $VERSION $COMPONENTS
deb http://deb.debian.org/debian $VERSION-updates $COMPONENTS
deb-src http://deb.debian.org/debian $VERSION-updates $COMPONENTS
deb http://security.debian.org/debian-security $VERSION-security $COMPONENTS
deb-src http://security.debian.org/debian-security $VERSION-security $COMPONENTS
EOF

cat <<EOF | sudo tee /etc/apt/sources.list.d/backports.list >/dev/null
deb http://deb.debian.org/debian $VERSION-backports $COMPONENTS
deb-src http://deb.debian.org/debian $VERSION-backports $COMPONENTS
EOF

cat <<EOF | sudo tee /etc/apt/apt.conf.d/99-no-install-recommends >/dev/null
APT::Install-Recommends "false";
APT::Install-Suggests "false";
EOF

sudo apt-get update

# tests
apt-config dump | grep 'APT::Install-Recommends "false";' >/dev/null
apt-config dump | grep 'APT::Install-Suggests "false";' >/dev/null
