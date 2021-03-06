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

if network_ok
then
    if is_this_installed ntpdate
    then
        ntpdate -s 1.se.pool.ntp.org
    fi
fi
exit
