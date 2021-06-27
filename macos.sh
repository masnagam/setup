PROGNAME=$(basename $0)
BASEDIR=$(cd $(dirname $0); pwd)

TARGET=macos
BASEURL=https://raw.githubusercontent.com/masnagam/setup/main

DOT_SSH=
GIT_USER_NAME=
GIT_USER_EMAIL=

help() {
  cat <<EOF
Usage:
  macos.sh [options]
  macos.sh -h | --help

Options:
  --dot-ssh <FOLDER>
    Path to a folder containing files to be copied into $HOME/.ssh.

  --git-user-name <GIT_USER_NAME>
    Git user.name.

  --git-user-email <GIT_USER_EMAIL>
    Git user.email.
EOF
  exit 0
}

while [ $# -gt 0 ]
do
  case "$1" in
    '-h' | '--help')
      help
      ;;
    '--dot-ssh')
      DOT_SSH="$2"
      shift 2
      ;;
    '--git-user-name')
      GIT_USER_NAME="$2"
      shift 2
      ;;
    '--git-user-email')
      GIT_USER_EMAIL="$2"
      shift 2
      ;;
    *)
      shift
      ;;
  esac
done

if [ -z "$GIT_USER_NAME" ]
then
  echo "ERROR: --git-user-name is required"
  exit 1
fi

if [ -z "$GIT_USER_EMAIL" ]
then
  echo "ERROR: --git-user-email required"
  exit 1
fi

if [ "$PROGNAME" = 'macos.sh' ]
then
  echo "INFO: Use local files in $BASEDIR instead of ones in $BASEURL"
  BASEURL="file://$BASEDIR"
fi

export SETUP_TARGET="$TARGET"
export SETUP_BASEURL="$BASEURL"
export SETUP_DOT_SSH="$DOT_SSH"
export SETUP_GIT_USER_NAME="$GIT_USER_NAME"
export SETUP_GIT_USER_EMAIL="$GIT_USER_EMAIL"

curl -fsSL $SETUP_BASEURL/scripts/alacritty.macos.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/tmux.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/bash.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/docker.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/ssh.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/git.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/emacs.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/rust.macos.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/sarasa-gothic.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/font-awesome-free.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/material-design-icons.sh | sh

mkdir -p $HOME/bin
cat <<EOF >$HOME/bin/run-setup-script
#!/bin/sh
export SETUP_TARGET=$SETUP_TARGET
export SETUP_BASEURL=$SETUP_BASEURL
export SETUP_DOT_SSH=$SETUP_DOT_SSH
export SETUP_GIT_USRE_NAEM=$SETUP_GIT_USER_NAME
export SETUP_GIT_USER_EMAIL=$SETUP_GIT_USER_EMAIL
curl -fsSL \$SETUP_BASEURL/scripts/\$1.sh | sh
EOF
cat <<EOF >$HOME/bin/fetch-setup-file
#!/bin/sh
curl -fsSL $SETUP_BASEURL/files/\$1
EOF
chmod +x $HOME/bin/run-setup-script
chmod +x $HOME/bin/fetch-setup-file
