if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

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

echo "Installing tools for Rust..."

case $SETUP_TARGET in
  arch)
    if ! which rustc >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/rust.sh | sh
    fi
    ;;
  debian)
    if ! which rustc >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/rust.sh | sh
    fi
    sudo apt-get install -y --no-install-recommends build-essential libssl-dev pkg-config
    ;;
  macos)
    if ! which rustc >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/rust.sh | sh
    fi
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

. $HOME/.bashrc.d/rust.sh

curl -fsSL $BINSTALL_URL | tar -xz -C $CARGO_HOME/bin --no-same-owner
cargo binstall --no-confirm cargo-binstall
for TOOL in $TOOLS
do
  # NOTE
  # ----
  # `cargo binstall` sometimes makes really many requests at the same time.  And
  # most of these requests fail with the status code 429 (Too Many Requests).
  # One of simple solutions is using the --rate-limit option, but it makes the
  # command slower...
  if [ "$TOOL" = cargo-audit ]
  then
    cargo install $TOOL
  else
    cargo binstall --no-confirm $TOOL
  fi
done

# tests
cargo audit --version
cargo cache --version
cargo expand --version
cargo license -h  # --version is not supported
grcov --version
