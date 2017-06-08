#!/bin/bash

DIR="/etc/update-motd.d"

rm -f $DIR/10-help-text
rm -f $DIR/51-cloudguest

header_conf=$(cat <<-EOF

timedatectl

if type 'screenfetch' > /dev/null; then
    screenfetch
fi


EOF
)

if [[ "$(cat $DIR/00-header)" != *"$header_conf"* ]]; then
    echo "$header_conf" >> $DIR/00-header
fi

