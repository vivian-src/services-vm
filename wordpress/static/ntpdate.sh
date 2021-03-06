#!/bin/bash



# shellcheck disable=2034,2059
true
# shellcheck source=lib.sh
. <(curl -sL https://raw.githubusercontent.com/vivian-src/services-vm/master/wordpress/lib.sh)

# Check for errors + debug code and abort if something isn't right
# 1 = ON
# 0 = OFF
DEBUG=0
debug_mode

if wget -q -T 10 -t 2 http://google.com > /dev/null
then
    ntpdate -s 1.se.pool.ntp.org
fi
exit
