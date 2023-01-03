if [ -n "$SETUP_DEBUG" ]
then
  set -ex
fi

PROGNAME=$(basename $0)
BASEDIR=$(cd $(dirname $0); pwd)

TARGET=arch
BASEURL=https://raw.githubusercontent.com/masnagam/setup/main

NET_IF=
DEVELOP=
DOT_SSH=
GIT_USER_NAME=
GIT_USER_EMAIL=
DESKTOP=

help() {
  cat <<EOF
Usage:
  arch.sh [options]
  arch.sh -h | --help

Options:
  --net-if <INTERFACE>
    Network interface like enp2s0.

Options for development environment:
  --develop
    Setup development environment.

  --dot-ssh <FOLDER>
    Path to a folder containing files to be copied into $HOME/.ssh.

  --git-user-name <GIT_USER_NAME>
    Git user.name.

  --git-user-email <GIT_USER_EMAIL>
    Git user.email.

Options for desktop environment:
  --desktop
    Setup desktop environment.
EOF
  exit 0
}

while [ $# -gt 0 ]
do
  case "$1" in
    '-h' | '--help')
      help
      ;;
    '--net-if')
      NET_IF="$2"
      shift 2
      ;;
    '--develop')
      DEVELOP=1
      shift
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
    '--desktop')
      DESKTOP=1
      shift
      ;;
    *)
      shift
      ;;
  esac
done

if [ -z "$NET_IF" ]
then
  echo "ERROR: --net-if is required"
  exit 1
fi

if [ "$PROGNAME" = 'arch.sh' ]
then
  echo "INFO: Use local files in $BASEDIR instead of ones in $BASEURL"
  BASEURL="file://$BASEDIR"
fi

export SETUP_TARGET="$TARGET"
export SETUP_BASEURL="$BASEURL"
export SETUP_NET_IF="$NET_IF"
export SETUP_DEVELOP="$DEVELOP"
export SETUP_DOT_SSH="$DOT_SSH"
export SETUP_GIT_USER_NAME="$GIT_USER_NAME"
export SETUP_GIT_USER_EMAIL="$GIT_USER_EMAIL"
export SETUP_DESKTOP="$DESKTOP"

sudo pacman -S --noconfirm archlinux-keyring

curl -fsSL $SETUP_BASEURL/scripts/network.linux.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/ntp.linux.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/tmux.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/bash.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/docker.sh | sh

curl -fsSL $SETUP_BASEURL/scripts/firmware.linux.sh | sh

if [ -n "$DEVELOP" ]
then
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

  curl -fsSL $SETUP_BASEURL/scripts/ssh.sh | sh
  curl -fsSL $SETUP_BASEURL/scripts/git.sh | sh
  curl -fsSL $SETUP_BASEURL/scripts/emacs.sh | sh
fi

if [ -n "$DESKTOP" ]
then
  curl -fsSL $SETUP_BASEURL/scripts/x11.linux.sh | sh
  curl -fsSL $SETUP_BASEURL/scripts/urxvt.linux.sh | sh
  curl -fsSL $SETUP_BASEURL/scripts/fcitx5-mozc.linux.sh | sh
  curl -fsSL $SETUP_BASEURL/scripts/i3.linux.sh | sh
  curl -fsSL $SETUP_BASEURL/scripts/polybar.linux.sh | sh
  curl -fsSL $SETUP_BASEURL/scripts/sarasa-gothic.sh | sh
  curl -fsSL $SETUP_BASEURL/scripts/font-awesome-free.sh | sh
  curl -fsSL $SETUP_BASEURL/scripts/material-design-icons.sh | sh
  curl -fsSL $SETUP_BASEURL/scripts/bluetooth.linux.sh | sh
fi

curl -fsSL $SETUP_BASEURL/scripts/nord-theme.sh | sh

mkdir -p $HOME/bin
cat <<EOF >$HOME/bin/run-setup-script
#!/bin/sh
export SETUP_TARGET=$SETUP_TARGET
export SETUP_BASEURL=$SETUP_BASEURL
export SETUP_NET_IF=$SETUP_NET_IF
export SETUP_DEVELOP=$SETUP_DEVELOP
export SETUP_DOT_SSH=$SETUP_DOT_SSH
export SETUP_GIT_USRE_NAEM=$SETUP_GIT_USER_NAME
export SETUP_GIT_USER_EMAIL=$SETUP_GIT_USER_EMAIL
export SETUP_DESKTOP=$SETUP_DESKTOP
curl -fsSL \$SETUP_BASEURL/scripts/\$1.sh | sh
EOF
cat <<EOF >$HOME/bin/fetch-setup-file
#!/bin/sh
curl -fsSL $SETUP_BASEURL/files/\$1
EOF
chmod +x $HOME/bin/run-setup-script
chmod +x $HOME/bin/fetch-setup-file
