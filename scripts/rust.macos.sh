if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing Rust..."

RUST_COMPONENTS='rust-src'
RUST_TOOLS='cargo-audit cargo-cache cargo-expand cargo-license cargo-update grcov'

if ! which -s brew
then
  curl -fsSL $SETUP_BASEURL/scripts/homebrew.macos.sh | sh
fi

if ! which rustup >/dev/null 2>&1
then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

CARGO_HOME=$HOME/.cargo
. $CARGO_HOME/env

for COMPONENT in $RUST_COMPONENTS
do
  rustup component add $COMPONENT
done

brew install rust-analyzer

for TOOL in $RUST_TOOLS
do
  cargo install $TOOL
done

mkdir -p $HOME/.bashrc.d
cat <<'EOF' >$HOME/.bashrc.d/rust.sh
. $HOME/.cargo/env
EOF

# tests
rustup --version
rustc --version
rust-analyzer --version
cargo audit --version
cargo cache --version
cargo expand --version
cargo license --version
cargo install-update --version
grcov --version
