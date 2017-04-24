#!/bin/bash

DIR="/etc/update-motd.d"

rm -f $DIR/10-help-text
rm -f $DIR/51-cloudguest

cat <<'EOF' > $DIR/00-header
#!/bin/bash

[ -r /etc/lsb-release ] && . /etc/lsb-release

if [ -z "$DISTRIB_DESCRIPTION" ] && [ -x /usr/bin/lsb_release ]; then
        # Fall back to using the very slow lsb_release utility
        DISTRIB_DESCRIPTION=$(lsb_release -s -d)
fi

printf "Welcome to %s (%s)\n" "$DISTRIB_DESCRIPTION" "$(uname -a)"
timedatectl

if [ $(type -t screenfetch) ]; then
    screenfetch
fi

EOF

chmod 755 $DIR/*

