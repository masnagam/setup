if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

REPO=masnagam/paru-build
JQ_FILTER='.assets[] | select(.name | contains("debug") | not) | .browser_download_url'

sudo pacman -S --noconfirm jq which

DOWNLOAD_URL=$(curl "https://api.github.com/repos/$REPO/releases/latest" -s | jq -r "$JQ_FILTER")
if [ -z "$DOWNLOAD_URL" ]
then
  echo "ERROR: Binary not found"
  exit 1
fi

TEMP_DIR=$(mktemp -d)
trap "rm -fr $TEMP_DIR" EXIT INT TERM

echo "Downloading $DOWNLOAD_URL..."
curl "$DOWNLOAD_URL" -fsSL -o "$TEMP_DIR/paru.pkg.tar.zst"

echo "Installing paru.pkg.tar.zst..."
sudo pacman -U --noconfirm "$TEMP_DIR/paru.pkg.tar.zst"

# tests
which paru
paru --version
