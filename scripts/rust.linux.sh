if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

COMPONENTS=$(cat <<EOF | tr '\n' ' '
rust-src
rust-analyzer
EOF
)

echo "Installing Rust..."

case $SETUP_TARGET in
  arch)
    ;;
  debian)
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
export CARGO_HOME=$HOME/.cargo
EOF

# tests
rustup --version
rustc --version
cargo --version
rust-analyzer --version
