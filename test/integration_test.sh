set -eux
set -o pipefail

TARGET="$1"
shift

vagrant up $TARGET

# Run twice in order to check idempotence of the script.
echo "============================== 1st run =============================="
vagrant ssh $TARGET -- sh -ex /vagrant/$TARGET.sh "$@"
echo "============================== 2nd run =============================="
vagrant ssh $TARGET -- sh -ex /vagrant/$TARGET.sh "$@"

vagrant ssh $TARGET -c 'run-setup-script bash'
vagrant ssh $TARGET -c 'fetch-setup-file emacs.init.el | head -1'

# The VM won't be destroyed when any test fails so that it makes it possible to debug the failure.
vagrant destroy -f $TARGET
