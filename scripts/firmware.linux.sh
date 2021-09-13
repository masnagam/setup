echo "Installing firmware..."

CPU=
if cat /proc/cpuinfo | grep -i intel >/dev/null
then
  CPU=intel
fi
if cat /proc/cpuinfo | grep -i amd >/dev/null
then
  CPU=amd
fi

case $SETUP_TARGET in
  arch)
    if ! which paru >/dev/null 2>&1
    then
      curl -fsSL $SETUP_BASEURL/scripts/paru.arch.sh | sh
    fi
    paru -S --noconfirm dmidecode linux-firmware
    if [ "$(sudo dmidecode -s system-family)" = 'Virtual Machine' ]
    then
       echo 'INFO: ucode will not be installed automatically for safety'
    else
      case $CPU in
        intel)
          paru -S --noconfirm intel-ucode
          ;;
        amd)
          paru -S --noconfirm amd-ucode
          ;;
      esac
    fi
    ;;
  debian)
    # use non-free
    if ! apt-cache policy | grep '/non-free' >/dev/null
    then
      curl -fsSL $SETUP_BASEURL/scripts/apt.debian.sh | sh
    fi
    sudo apt-get install -y --no-install-recommends dmidecode firmware-linux
    if [ "$(sudo dmidecode -s system-family)" = 'Virtual Machine' ]
    then
       echo 'INFO: ucode will not be installed automatically for safety'
    else
      case $CPU in
        intel)
          paru -S --noconfirm intel-ucode
          ;;
        amd)
          paru -S --noconfirm amd-ucode
          ;;
      esac
    fi
    if cat /proc/cpuinfo | grep -i intel >/dev/null
    then
      echo "INFO: intel-microcode won't be installed automatically for safety"
    fi
    if cat /proc/cpuinfo | grep -i amd >/dev/null
    then
      echo "INFO: amd-microcode won't be installed automatically for safety"
    fi
    ;;
  *)
    echo "ERROR: Target not supported: $SETUP_TARGET"
    exit 1
    ;;
esac
