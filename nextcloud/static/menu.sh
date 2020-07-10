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
print_text_in_color "$ICyan" "Running the main menu script..."

if network_ok
then
    # Delete, download, run
    run_script STATIC main_menu
fi

exit
