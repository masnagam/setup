RUST_COMPONENTS='rust-src'
CARGO_TOOLS='cargo-audit cargo-cache cargo-expand cargo-license cargo-update grcov'

case $SETUP_TARGET in
  debian)
    echo "Installing packages..."
    sudo apt-get install -y build-essential git jq libssl-dev pkg-config
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

. $HOME/.cargo/env

for COMPONENT in $RUST_COMPONENTS
do
  echo "Installing $COMPONENT..."
  rustup component add $COMPONENT
done

for TOOL in $CARGO_TOOLS
do
  echo "Installing $TOOL..."
  cargo install $TOOL
done

echo "Installing rust-analyzer..."
RUST_ANALYZER_LATEST=https://api.github.com/repos/rust-analyzer/rust-analyzer/releases/latest
RUST_ANALYZER_TAG="$(curl -fsSL $RUST_ANALYZER_LATEST | jq -r .tag_name)"
if ! rust-analyzer --version | grep "$RUST_ANALYZER_TAG" >/dev/null
then
  RUST_ANALYZER_SRC=$(mktemp -d)
  git clone --depth=1 --branch="$RUST_ANALYZER_TAG" \
    https://github.com/rust-analyzer/rust-analyzer.git $RUST_ANALYZER_SRC
  trap "rm -rf $RUST_ANALYZER_SRC" EXIT
  (cd $RUST_ANALYZER_SRC; cargo xtask install --server)
fi

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
