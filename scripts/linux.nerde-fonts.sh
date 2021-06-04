echo "Installing Nerd Fonts..."

FONT=Iosevka

case $SETUP_TARGET in
  debian)
    sudo apt-get install -y --no-install-recommends fontconfig jq unzip
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac

mkdir -p $HOME/.local/share/fonts

LATEST_URL=https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest
DL_URL="$(curl -fsSL $LATEST_URL | jq -Mr '.assets[].browser_download_url' | grep $FONT)"
if [ -z "$DL_URL" ]
then
  # FIXME
  # -----
  # `curl -fsSL` suddenly gets to fail in GitHub Actions with an unknown error...:
  # https://github.com/masnagam/setup/runs/2710714366?check_suite_focus=true#step:4:2423
  # https://github.com/masnagam/setup/runs/2711894137?check_suite_focus=true#step:4:2427 (curl -vfL)
  #
  # `curl -sG` also fails:
  # https://github.com/masnagam/setup/runs/2712001873?check_suite_focus=true#step:4:2428
  #
  # However, `curl -v` finishes successfully:
  # https://github.com/masnagam/setup/runs/2711805337?check_suite_focus=true#step:4:4492
  #
  # These never fail on actual machines.
  echo 'WARN: `curl -fsSL` failed, retry with `curl -v`'
  DL_URL="$(curl -v $LATEST_URL | jq -Mr '.assets[].browser_download_url' | grep $FONT)"
fi

ARCHIVE=$(mktemp)
trap "rm -f $ARCHIVE" EXIT

curl -fsSL "$DL_URL" >$ARCHIVE
unzip -od $HOME/.local/share/fonts $ARCHIVE
fc-cache -f

# tests
fc-list | grep $FONT >/dev/null
