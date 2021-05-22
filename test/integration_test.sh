set -eux
set -o pipefail

TARGET="$1"
shift

trap "vagrant destroy -f $TARGET" EXIT
vagrant up $TARGET

# Run twice in order to check idempotence of the script.
echo "============================== 1st run =============================="
vagrant ssh $TARGET -- sh -ex /vagrant/$TARGET.sh "$@"
echo "============================== 2nd run =============================="
vagrant ssh $TARGET -- sh -ex /vagrant/$TARGET.sh "$@"
