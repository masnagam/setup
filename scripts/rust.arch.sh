COMPONENTS='rust-src'
TOOLS='cargo-audit cargo-cache cargo-expand cargo-license cargo-update grcov'

if ! which paru >/dev/null 2>&1
then
  curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
fi

echo "Installing Rust..."

if ! which rustup >/dev/null 2>&1
then
  paru -S --noconfirm rustup
fi

CARGO_HOME=$HOME/.cargo
. $CARGO_HOME/env

for COMPONENT in $COMPONENTS
do
  rustup component add $COMPONENT
done

for TOOL in $TOOLS
do
  cargo install $TOOL
done

paru -S --noconfirm rust-analyzer

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
