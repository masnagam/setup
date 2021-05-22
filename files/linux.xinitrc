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
  for f in /etc/X11/xinit/xinitrc.d/?*.sh
  do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

if [ -d $HOME/.xinitrc.d ]
then
  for f in $HOME/.xinitrc.d/?*.sh
  do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

if [ -f $HOME/.xinitrc.d/exec-wm ]
  . $HOME/.xinitrc.d/exec-wm
then
