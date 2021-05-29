if [ -d $HOME/.profile.d ]
then
  for script in $HOME/.profile.d/*.sh
  do
    test -r "$script" && . "$script"
  done
  unset script
fi

if echo "$PATH" | grep /usr/local/bin >/dev/null 2>&1
then
  export PATH="/usr/local/bin:$PATH"
fi

export PATH="$HOME/bin:$PATH"

if [ -f $HOME/.bashrc ]
then
  . $HOME/.bashrc
fi

if [ -f $HOME/.xinitrc ] && [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ]
then
  exec startx
fi
