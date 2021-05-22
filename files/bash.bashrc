# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -z "$LANG" ]
then
  export LANG=en_US.UTF-8
fi

# status indicators

status_face() {
  local _status=$?

  # Use \001 and \002 instead of \[ and \].  The latter texts won't be
  # interpreted as espace sequences and they will be shown as normal texts.
  local _GREEN='\001\e[32m\002'
  local _RED='\001\e[31m\002'
  local _RESET='\001\e[0m\002'

  if [ $_status -eq 0 ]
  then
    local _color=$_GREEN
    local _face='^_^)/'
  else
    local _color=$_RED
    local _face='>_<)\\'
  fi

  echo -en "${_color}${_face}${_RESET} "
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

PS1="\n\u@\h:\w$PS1_STATUS\n$PS1_STATUS_FACE"

eval "$(direnv hook bash)"  # must be placed at the last line
