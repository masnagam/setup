if [ -d $HOME/.profile.d ]
then
  for script in $HOME/.profile.d/*.sh
  do
    test -r "$script" && . "$script"
  done
  unset script
fi

if [[ ":$PATH:" != *":/usr/local/bin:"* ]]
then
  export PATH="/usr/local/bin:$PATH"
fi

if [[ ":$PATH:" != *":$HOME/bin:"* ]]
then
  export PATH="$HOME/bin:$PATH"
fi

if [ -f $HOME/.bashrc ]
then
  . $HOME/.bashrc
fi

if [ -f $HOME/.xinitrc ] && [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ]
then
  exec startx
fi
