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

download_script STATIC update-config
if [ -f $SCRIPTS/update-config.php ]
then
    # Change config.php
    php $SCRIPTS/update-config.php $NCPATH/config/config.php 'trusted_domains[]' localhost "${ADDRESS[@]}" "$(hostname)" "$(hostname --fqdn)" >/dev/null 2>&1
    php $SCRIPTS/update-config.php $NCPATH/config/config.php overwrite.cli.url https://"$(hostname --fqdn)"/ >/dev/null 2>&1

    # Change .htaccess accordingly
    sed -i "s|RewriteBase /nextcloud|RewriteBase /|g" $NCPATH/.htaccess

    # Cleanup
    rm -f $SCRIPTS/update-config.php
fi
