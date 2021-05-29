set -eux
set -o pipefail

TARGET="$1"
SCRIPT="$2"

BASEDIR=/vagrant

ENVS=$(cat <<EOF | tr '\n' ' '
SETUP_TARGET=$TARGET
SETUP_BASEURL=file://$BASEDIR
SETUP_NET_IF='eth*'
SETUP_DOT_SSH=$BASEDIR/test/dot.ssh
SETUP_GIT_USER_NAME=vagrant
SETUP_GIT_USER_EMAIL=vagrant@setup.example
EOF
)

vagrant up $TARGET

# Run twice in order to check idempotence of the script.
echo "============================== 1st run =============================="
cat $SCRIPT | vagrant ssh $TARGET -- env $ENVS sh -ex
echo "============================== 2nd run =============================="
cat $SCRIPT | vagrant ssh $TARGET -- env $ENVS sh -ex

# The VM won't be destroyed when any test fails so that it makes it possible to debug the failure.
vagrant destroy -f $TARGET
