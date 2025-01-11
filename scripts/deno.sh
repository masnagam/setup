if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing Deno..."

if ! which deno >/dev/null 2>&1
then
  curl -fsSL https://deno.land/install.sh | env DENO_INSTALL="$HOME/.deno" sh
fi

mkdir -p $HOME/.bashrc.d
cat <<'EOF' >$HOME/.bashrc.d/deno.sh
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
EOF

# tests
"$HOME/.deno/bin/deno" --version
