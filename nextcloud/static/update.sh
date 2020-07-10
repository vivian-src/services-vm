#!/bin/bash



# shellcheck disable=2034,2059
true
# shellcheck source=lib.sh
. <(curl -sL https://raw.githubusercontent.com/vivian-src/services-vm/master/nextcloud/lib.sh)

# Check for errors + debug code and abort if something isn't right
# 1 = ON
# 0 = OFF
DEBUG=0
debug_mode

# Must be root
root_check

mkdir -p "$SCRIPTS"

if [ "${1}" = "minor" ]
then
    echo "$((NCMAJOR-1))" > /tmp/minor.version
elif [ "${1}" = "beta" ]
then
    echo "beta" > /tmp/prerelease.version
elif [[ "${1}" == *"RC"* ]]
then
    echo "${1}" > /tmp/prerelease.version
fi

# Delete, download, run
run_script GITHUB_REPO nextcloud_update

exit
