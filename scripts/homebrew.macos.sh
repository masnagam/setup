if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

# This script works only on macOS.

echo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
