sed -i -e '/^deb .*-backports .*$/d' /etc/apt/sources.list
sed -i -e '/^deb-src .*-backports .*$/d' /etc/apt/sources.list
apt-get update -qq
apt-get install -y -qq --no-install-recommends ca-certificates curl
DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends console-setup
