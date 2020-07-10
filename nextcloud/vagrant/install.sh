#!/bin/bash

# shellcheck disable=2034,2059
true
# shellcheck source=lib.sh
. <(curl -sL https://raw.githubusercontent.com/vivian-src/services-vm/master/nextcloud/lib.sh)

check_command git clone https://github.com/vivian-src/services-vm/nextcloud.git

cd vm || exit && print_text_in_color "$IRed" "Could not cd into the 'vm' folder."

yes no | sudo bash nextcloud_install_production.sh
