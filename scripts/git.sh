if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

echo "Installing git..."

if [ -z "$SETUP_GIT_USER_NAME" ]
then
  echo "ERROR: SETUP_GIT_USER_NAME is required"
  exit 1
fi

if [ -z "$SETUP_GIT_USER_EMAIL" ]
then
  echo "ERROR: SETUP_GIT_USER_EMAIL is required"
  exit 1
fi

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm git
    GIT_PROMPT_SCRIPT=/usr/share/git/completion/git-prompt.sh
    ;;
  debian)
    sudo apt-get install -y --no-install-recommends git
    GIT_PROMPT_SCRIPT=/etc/bash_completion.d/git-prompt
    ;;
  macos)
    if ! which -s brew
    then
      curl -fsSL $SETUP_BASEURL/scripts/homebrew.macos.sh | sh
    fi
    brew install git tig gnu-sed
    GIT_PROMPT_SCRIPT=/usr/local/etc/bash_completion.d/git-prompt.sh
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

git config --global core.autocrlf input
git config --global core.safecrlf true
git config --global fetch.prune true
git config --global merge.ff false
git config --global pull.ff only
git config --global pull.rebase true
git config --global user.name "$SETUP_GIT_USER_NAME"
git config --global user.email "$SETUP_GIT_USER_EMAIL"

mkdir -p $HOME/.bashrc.d
curl -fsSL $SETUP_BASEURL/files/bash.git-prompt.sh | \
  sed "s|{{SETUP_GIT_PROMPT_SCRIPT}}|$GIT_PROMPT_SCRIPT|g" \
    >$HOME/.bashrc.d/git-prompt.sh

# tests
git version
test "$(git config user.name)" = "$SETUP_GIT_USER_NAME"
test "$(git config user.email)" = "$SETUP_GIT_USER_EMAIL"
