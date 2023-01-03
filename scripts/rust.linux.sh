if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

COMPONENTS=$(cat <<EOF | tr '\n' ' '
rust-src
EOF
)

TOOLS=$(cat <<EOF | tr '\n' ' '
cargo-audit
cargo-cache
cargo-edit
cargo-expand
cargo-license
grcov
EOF
)

BINSTALL_URL=https://github.com/cargo-bins/cargo-binstall/releases/latest/download/cargo-binstall-x86_64-unknown-linux-musl.tgz

echo "Installing Rust..."

case $SETUP_TARGET in
  arch)
    ;;
  debian)
    sudo apt-get install -y --no-install-recommends build-essential libssl-dev pkg-config
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

mkdir -p $HOME/.bashrc.d
cat <<'EOF' >$HOME/.bashrc.d/rust.sh
. $HOME/.cargo/env
EOF

. $HOME/.bashrc.d/rust.sh
curl -fsSL $BINSTALL_URL | tar -xz -C $CARGO_HOME/bin --no-same-owner

cargo binstall --no-confirm --rate-limit=100 cargo-binstall
for TOOL in $TOOLS
do
  cargo binstall --no-confirm --rate-limit=100 $TOOL
done
# rust-analyzer
mkdir -p $HOME/bin
curl -fsSL https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gzip -cd - >$HOME/bin/rust-analyzer
chmod +x $HOME/bin/rust-analyzer

# tests
rustup --version
rustc --version
cargo --version
cargo audit --version
cargo cache --version
cargo expand --version
cargo license -h  # --version is not supported
grcov --version
$HOME/bin/rust-analyzer --version
test "$(stat -c "%U %G" $HOME/bin/rust-analyzer)" = "$(id -un) $(id -gn)"
