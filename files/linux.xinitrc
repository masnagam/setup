USER_XRESOURCES="$HOME/.Xresources"
USER_XMODMAP="$HOME/.Xmodmap"
SYS_XRESOURCES=/etc/X11/xinit/.Xresources
SYS_MODMAP=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $SYS_XRESOURCES ]
then
  xrdb -merge $SYS_XRESOURCES
fi

if [ -f $SYS_MODMAP ]
then
  xmodmap $SYS_MODMAP
fi

if [ -f "$USER_XRESOURCES" ]
then
  xrdb -merge "$USER_XRESOURCES"
fi

if [ -f "$USER_XMODMAP" ]
then
  xmodmap "$USER_XMODMAP"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ]
then
  for script in /etc/X11/xinit/xinitrc.d/*.sh
  do
    test -r "$script" && . "$script"
  done
  unset script
fi

if [ -d $HOME/.xinitrc.d ]
then
  for script in $HOME/.xinitrc.d/*.sh
  do
    test -r "$script" && . "$script"
  done
  unset script
fi

if [ -f $HOME/.xinitrc.d/exec-wm ]
then
  . $HOME/.xinitrc.d/exec-wm
fi
