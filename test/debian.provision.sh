sed -i 's/^\(deb .*\) main$/\1 main contrib non-free/' /etc/apt/sources.list
sed -i 's/^\(deb-src .*\) main$/\1 main contrib non-free/' /etc/apt/sources.list
apt-get update -qq
apt-get install -y -qq --no-install-recommends ca-certificates curl
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends console-setup
