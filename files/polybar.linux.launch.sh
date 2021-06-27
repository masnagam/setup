# https://wiki.archlinux.org/title/Polybar#Running_with_WM
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
polybar top &
echo "Polybar launched..."
