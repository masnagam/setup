RUST_COMPONENTS='rust-src'

# TODO: SETUP_TARGET should contain the version.
DEBIAN_VERSION=buster

# docker is required
if ! which docker >/dev/null
then
  curl -fsSL $SETUP_BASEURL/scripts/docker.sh | sh
fi

case $SETUP_TARGET in
  debian)
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

echo "Installing rustup..."
if ! which rustup >/dev/null 2>&1
then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

CARGO_HOME=$HOME/.cargo
. $CARGO_HOME/env

for COMPONENT in $RUST_COMPONENTS
do
  echo "Installing $COMPONENT..."
  rustup component add $COMPONENT
done

echo "Install tools..."
curl -fsSL https://raw.githubusercontent.com/masnagam/docker-rust-tools/main/get-rust-tools | \
  sh -s -- $SETUP_TARGET-$DEBIAN_VERSION | tar -xz -C $CARGO_HOME/bin --no-same-owner

echo "Installing $HOME/.bashrc.d/99-rust.sh..."
mkdir -p $HOME/.bashrc.d
cat <<'EOF' >$HOME/.bashrc.d/99-rust.sh
. $HOME/.cargo/env
EOF

# tests
rustup --version
rustc --version
rust-analyzer --version
cargo audit --version
cargo expand --version
cargo license --version
cargo install-update --version
grcov --version
test "$(stat -c "%U %G" $(which rust-analyzer))" = "$(id -un) $(id -gn)"
