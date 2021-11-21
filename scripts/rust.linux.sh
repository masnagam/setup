if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

COMPONENTS='rust-src'
GET_RUST_TOOLS=https://raw.githubusercontent.com/masnagam/docker-rust-tools/main/get-rust-tools

# docker is required
if ! which docker >/dev/null
then
  curl -fsSL $SETUP_BASEURL/scripts/docker.sh | sh
fi

echo "Installing Rust..."

case $SETUP_TARGET in
  arch | debian)
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

if ! which rustup >/dev/null 2>&1
then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

CARGO_HOME=$HOME/.cargo
. $CARGO_HOME/env

for COMPONENT in $COMPONENTS
do
  rustup component add $COMPONENT
done

curl -fsSL $GET_RUST_TOOLS | sh -s | tar -xz -C $CARGO_HOME/bin --no-same-owner

mkdir -p $HOME/.bashrc.d
cat <<'EOF' >$HOME/.bashrc.d/rust.sh
. $HOME/.cargo/env
EOF

# tests
rustup --version
rustc --version
cargo --version
rust-analyzer --version
cargo audit --version
cargo cache --version
cargo expand --version
cargo license --version
cargo install-update --version
grcov --version
test "$(stat -c "%U %G" $(which rust-analyzer))" = "$(id -un) $(id -gn)"
