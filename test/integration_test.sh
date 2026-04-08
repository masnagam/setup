set -eu

SRCDIR=$(cd $(dirname $0)/..; pwd)

TARGET="$1"
shift

case $TARGET in
  arch)
    IMGURL='https://fastly.mirror.pkgbuild.com/images/v20260401.509747/Arch-Linux-x86_64-cloudimg.qcow2'
    IMGSHA='95f7f9aebcb82d2046d3251bba1053085654dd12ab3237cb8acc81d4731f6227'
    SHASUM=sha256sum
    ;;
  debian)
    IMGURL='https://cloud.debian.org/images/cloud/trixie/20260402-2435/debian-13-generic-amd64-20260402-2435.qcow2'
    IMGSHA='584b03fd81dd85247a20fa2f1ea5ceae53094a52f62d0f9fa9ee7a2826e18c3734a77f801b110b9af79d0ea593f99c25936f7cf65eff0562eabc6223b861110a'
    SHASUM=sha512sum
    ;;
  *)
    exit 1
    ;;
esac

cleanup() {
  pkill -f qemu-system-x86_64 || true
  rm -f img.qcow2 seed.img user-data
}

trap cleanup EXIT INT TERM

export SSHPASS=test

cat <<EOF >user-data
#cloud-config
ssh_pwauth: true
users:
  - name: test
    lock_passwd: false
    plain_text_passwd: $SSHPASS
    shell: /bin/bash
    groups: sudo
    sudo:
      - 'ALL=(ALL) NOPASSWD:ALL'
EOF

cloud-localds seed.img user-data

echo "Downloading image..."
curl "$IMGURL" -fsSL >img.qcow2

echo "Checking image..."
$SHASUM -b img.qcow2 | cut -d ' ' -f 1 | grep -q $IMGSHA

echo "Resizing image..."
qemu-img resize img.qcow2 +10G

QEMU_OPTIONS="-daemonize"
if [ -e /dev/kvm ]
then
  echo "QEMU: Enabling KVM"
  QEMU_OPTIONS="$QEMU_OPTIONS -enable-kvm -cpu host"
else
  echo "QEMU: Disabling KVM"
  QEMU_OPTIONS="$QEMU_OPTIONS -cpu max"
fi
QEMU_OPTIONS="$QEMU_OPTIONS -m 2G"
QEMU_OPTIONS="$QEMU_OPTIONS -display none"
QEMU_OPTIONS="$QEMU_OPTIONS -net nic,model=virtio"
QEMU_OPTIONS="$QEMU_OPTIONS -net user,hostfwd=tcp::2222-:22"
QEMU_OPTIONS="$QEMU_OPTIONS -drive file=img.qcow2,if=virtio"
QEMU_OPTIONS="$QEMU_OPTIONS -drive file=seed.img,format=raw,if=virtio,readonly=on"
QEMU_OPTIONS="$QEMU_OPTIONS -virtfs local,path=$SRCDIR,mount_tag=host_share,security_model=none,id=fsdev0,readonly=on"

qemu-system-x86_64 $QEMU_OPTIONS

SSH_OPTIONS="-q"
#SSH_OPTIONS="-v"  # for debugging
SSH_OPTIONS="$SSH_OPTIONS -p 2222"
SSH_OPTIONS="$SSH_OPTIONS -o StrictHostKeyChecking=no"
SSH_OPTIONS="$SSH_OPTIONS -o UserKnownHostsFile=/dev/null"

echo "Waiting for VM to boot..."
until sshpass -e ssh $SSH_OPTIONS test@localhost exit
do
  sleep 5
done

echo "Mounting the source tree at /mnt/setup..."
MOUNT_SETUP="sudo mkdir -p /mnt/setup"
MOUNT_SETUP="$MOUNT_SETUP && sudo mount -t 9p -o trans=virtio host_share /mnt/setup"
sshpass -e ssh $SSH_OPTIONS test@localhost "$MOUNT_SETUP"

case $TARGET in
  arch)
    echo "Resetting gpg keys..."
    sshpass -e ssh $SSH_OPTIONS test@localhost sudo rm -rf /etc/pacman.d/gnupg
    sshpass -e ssh $SSH_OPTIONS test@localhost sudo pacman-key --init
    sshpass -e ssh $SSH_OPTIONS test@localhost sudo pacman-key --populate
    ;;
  debian)
    ;;
esac

echo "Performing printenv..."
sshpass -e ssh $SSH_OPTIONS test@localhost printenv

ENVS="SETUP_DEBUG=1"
ENVS="$ENVS SETUP_GITHUB_TOKEN=${SETUP_GITHUB_TOKEN:-}"

# Run twice in order to check idempotence of the script.
echo "============================== 1st run =============================="
sshpass -e ssh $SSH_OPTIONS test@localhost env $ENVS sh /mnt/setup/$TARGET.sh "$@"
echo "============================== 2nd run =============================="
sshpass -e ssh $SSH_OPTIONS test@localhost env $ENVS sh /mnt/setup/$TARGET.sh "$@"

sshpass -e ssh $SSH_OPTIONS test@localhost env $ENVS /home/test/bin/run-setup-script bash
sshpass -e ssh $SSH_OPTIONS test@localhost env $ENVS sh -c '/home/test/bin/fetch-setup-file emacs.init.el | head -1'

echo "============================== SUUCESS =============================="
