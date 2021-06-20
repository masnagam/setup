PROGNAME=$(basename $0)
BASEDIR=$(cd $(dirname $0); pwd)

TARGET=debian
BASEURL=https://raw.githubusercontent.com/masnagam/setup/main

NET_IF=
DEVELOP=
DOT_SSH=
GIT_USER_NAME=
GIT_USER_EMAIL=
DESKTOP=
SERVER=
EMAIL=

help() {
  cat <<EOF
Usage:
  debian.sh [options]
  debian.sh -h | --help

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

Options for server:
  --server
    Setup server.

  --email
    Email address used for notifications.

EOF
  exit 0
}

while [ $# -gt 0 ]
do
  case "$1" in
    '-h' | '--help')
      help
      ;;
    '--develop')
      DEVELOP=1
      shift
      ;;
    '--desktop')
      DESKTOP=1
      shift
      ;;
    '--server')
      SERVER=1
      shift
      ;;
    '--net-if')
      NET_IF="$2"
      shift 2
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
    '--email')
      EMAIL="$2"
      shift 2
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

if [ "$PROGNAME" = 'debian.sh' ]
then
  echo "INFO: Use local files in $BASEDIR instead of ones in $BASEURL"
  BASEURL="file://$BASEDIR"
fi

export SETUP_TARGET="$TARGET"
export SETUP_BASEURL="$BASEURL"
export SETUP_NET_IF="$NET_IF"
export SETUP_DOT_SSH="$DOT_SSH"
export SETUP_GIT_USER_NAME="$GIT_USER_NAME"
export SETUP_GIT_USER_EMAIL="$GIT_USER_EMAIL"
export SETUP_EMAIL="$EMAIL"

curl -fsSL $SETUP_BASEURL/scripts/debian.apt.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/linux.firmware.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/linux.disable-ipv6.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/debian.network.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/debian.ntp.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/bash.sh | sh
curl -fsSL $SETUP_BASEURL/scripts/docker.sh | sh

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
  curl -fsSL $SETUP_BASEURL/scripts/linux.rust.sh | sh
fi

if [ -n "$DESKTOP" ]
then
  curl -fsSL $SETUP_BASEURL/scripts/linux.x11.sh | sh
  curl -fsSL $SETUP_BASEURL/scripts/linux.urxvt.sh | sh
  curl -fsSL $SETUP_BASEURL/scripts/linux.fcitx-mozc.sh | sh
  curl -fsSL $SETUP_BASEURL/scripts/linux.i3.sh | sh
  curl -fsSL $SETUP_BASEURL/scripts/linux.sarasa-gothic.sh | sh
  curl -fsSL $SETUP_BASEURL/scripts/linux.font-awesome-free.sh | sh
  curl -fsSL $SETUP_BASEURL/scripts/linux.material-design-icons.sh | sh
fi

if [ -n "$SERVER" ]
then
  if [ -z "$EMAIL" ]
  then
    echo "ERROR: --email is required"
    exit 1
  fi

  curl -fsSL $SETUP_BASEURL/scripts/debian.unattended-upgrades.sh
  curl -fsSL $SETUP_BASEURL/scripts/linux.ssh-server.sh | sh
fi

curl -fsSL $SETUP_BASEURL/scripts/nord-theme.sh | sh

sudo apt-get autoremove -y --purge

mkdir -p $HOME/bin
cat <<EOF >$HOME/bin/run-setup-script
#!/bin/sh
export SETUP_TARGET=$SETUP_TARGET
export SETUP_BASEURL=$SETUP_BASEURL
export SETUP_NET_IF=$SETUP_NET_IF
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
