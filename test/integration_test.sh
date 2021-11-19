set -e

TARGET="$1"
shift

ENVS=$(cat <<EOF | tr '\n' ' '
SETUP_DEBUG=1
SETUP_GITHUB_TOKEN=$SETUP_GITHUB_TOKEN
EOF
)

vagrant up $TARGET

# Run twice in order to check idempotence of the script.
echo "============================== 1st run =============================="
vagrant ssh $TARGET -- env $ENVS sh /vagrant/$TARGET.sh "$@"
echo "============================== 2nd run =============================="
vagrant ssh $TARGET -- env $ENVS sh /vagrant/$TARGET.sh "$@"

vagrant ssh $TARGET -c "env $ENVS run-setup-script bash"
vagrant ssh $TARGET -c "env $ENVS fetch-setup-file emacs.init.el | head -1"

# The VM won't be destroyed when any test fails so that it makes it possible to debug the failure.
vagrant destroy -f $TARGET
