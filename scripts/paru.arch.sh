if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing paru..."

if ! which git >/dev/null 2>&1
then
  sudo pacman -S --noconfirm git
fi

if ! which jq >/dev/null 2>&1
then
  sudo pacman -S --noconfirm jq
fi

# Do not run rust.linux.sh for installing rust.
# That causes a cyclic dependency issue.
if ! which rustup >/dev/null 2>&1
then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

CARGO_HOME=$HOME/.cargo
. $CARGO_HOME/env

LATEST_URL=https://api.github.com/repos/Morganamilo/paru/releases/latest
if [ -n "$SETUP_GITHUB_TOKEN" ]
then
  GITHUB_API_AUTH_HEADER="Authorization: token $SETUP_GITHUB_TOKEN"
else
  GITHUB_API_AUTH_HEADER=
fi
TAG=$(curl $LATEST_URL -fsSL -H "$GITHUB_API_AUTH_HEADER" | jq -Mr '.tag_name')

# Install from GitHub, instead of AUR.
# paru requires rust and rust will be installed from pacman repo unintentionally.
#
# --locked is required for avoiding build errors.
echo "Building $TAG..."
cargo install --git=https://github.com/Morganamilo/paru.git --tag=$TAG --locked

# tests
paru -V
test "$(which cargo)" != /usr/bin/cargo
