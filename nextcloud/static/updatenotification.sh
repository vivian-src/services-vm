#!/bin/bash



# shellcheck disable=2034,2059
true
# shellcheck source=lib.sh
NC_UPDATE=1 . <(curl -sL https://raw.githubusercontent.com/vivian-src/services-vm/master/nextcloud/lib.sh)
unset NC_UPDATE

print_text_in_color "$ICyan" "Checking for new Nextcloud version..."

# Check for errors + debug code and abort if something isn't right
# 1 = ON
# 0 = OFF
DEBUG=0
debug_mode

# Check if root
root_check

NCMIN=$(curl -s -m 900 $NCREPO/ | sed --silent 's/.*href="nextcloud-\([^"]\+\).zip.asc".*/\1/p' | sort --version-sort | grep "${CURRENTVERSION%%.*}" | tail -1)
REPORTEDMAJ="$CURRENTVERSION"
REPORTEDMIN="$CURRENTVERSION"

if [ "$CURRENTVERSION" == "$NCVERSION" ] && [ "$CURRENTVERSION" == "$NCMIN" ]
then
    print_text_in_color "$IGreen" "You already run the latest version! ($NCVERSION)"
    exit
fi

if [ "$REPORTEDMAJ" == "$NCVERSION" ] && [ "$REPORTEDMIN" == "$NCMIN" ]
then
    print_text_in_color "$ICyan" "The notification regarding the new Nextcloud update has been already reported!"
    exit
fi

if [ "$NCVERSION" == "$NCMIN" ] && version_gt "$NCMIN" "$REPORTEDMIN" && version_gt "$NCMIN" "$CURRENTVERSION"
then
    sed -i "s|^REPORTEDMAJ.*|REPORTEDMAJ=$NCVERSION|" $SCRIPTS/updatenotification.sh
    sed -i "s|^REPORTEDMIN.*|REPORTEDMIN=$NCMIN|" $SCRIPTS/updatenotification.sh
    if crontab -l -u root | grep -q $SCRIPTS/update.sh
    then
        notify_admin_gui \
        "New minor Nextcloud Update!" \
        "Nextcloud $NCMIN just became available. Since you are running Automatic Updates on Saturdays at $AUT_UPDATES_TIME:00, you don't need to bother about updating the server to minor Nextcloud versions manually, as that's already taken care of."
    else
        notify_admin_gui \
        "New minor Nextcloud Update!" \
        "Nextcloud $NCMIN just became available. Please run 'sudo bash /var/scripts/update.sh minor' from your CLI to update your server to Nextcloud $NCMIN."
    fi
    exit
fi

if version_gt "$NCMIN" "$REPORTEDMIN" && version_gt "$NCMIN" "$CURRENTVERSION"
then
    sed -i "s|^REPORTEDMIN.*|REPORTEDMIN=$NCMIN|" $SCRIPTS/updatenotification.sh
    if crontab -l -u root | grep -q $SCRIPTS/update.sh
    then
        notify_admin_gui \
        "New minor Nextcloud Update!" \
        "Nextcloud $NCMIN just became available. Since you are running Automatic Updates on Saturdays at $AUT_UPDATES_TIME:00, you don't need to bother about updating the server to minor Nextcloud versions manually, as that's already taken care of."
    else
        notify_admin_gui \
        "New minor Nextcloud Update!" \
        "Nextcloud $NCMIN just became available. Please run 'sudo bash /var/scripts/update.sh minor' from your CLI to update your server to Nextcloud $NCMIN."
    fi
fi

if version_gt "$NCVERSION" "$REPORTEDMAJ" && version_gt "$NCVERSION" "$CURRENTVERSION"
then
    sed -i "s|^REPORTEDMAJ.*|REPORTEDMAJ=$NCVERSION|" $SCRIPTS/updatenotification.sh
    notify_admin_gui \
    "New major Nextcloud Update!" \
    "Nextcloud $NCVERSION just became available. Please run 'sudo bash /var/scripts/update.sh' from your CLI to update your server to Nextcloud $NCVERSION."
fi
