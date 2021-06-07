echo "Installing firmware..."

case $SETUP_TARGET in
  debian)
    # use non-free
    if ! apt-cache policy | grep '/non-free' >/dev/null
    then
      curl -fsSL $SETUP_BASEURL/scripts/debian.apt.sh | sh
    fi

    sudo apt-get install -y --no-install-recommends firmware-linux
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
