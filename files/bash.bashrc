# Prevent accidental C-d closes the shell.
set -o ignoreeof

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -z "$LANG" ]
then
  export LANG=en_US.UTF-8
fi

TERM_COLOR_GREEN='\e[32m'
TERM_COLOR_RED='\e[31m'
TERM_COLOR_RESET='\e[0m'

# status indicators

status_face() {
  local _status=$?

  if [ $_status -eq 0 ]
  then
    local _color=$TERM_COLOR_GREEN
    local _face='^_^)/'
  else
    local _color=$TERM_COLOR_RED
    local _face='>_<)\\'
  fi

  echo -en "${_color}${_face}${TERM_COLOR_RESET} "
}

PS1_STATUS=
PS1_STATUS_FACE='$(status_face)'

# additional scripts

if [ -d $HOME/.bashrc.d ]
then
  for script in $HOME/.bashrc.d/*.sh
  do
    test -r "$script" && . "$script"
  done
  unset script
fi

# prompt

PS1="\n\u@$TERM_COLOR_RED\h$TERM_COLOR_RESET:\w$PS1_STATUS\n$PS1_STATUS_FACE"

eval "$(direnv hook bash)"  # must be placed at the last line
