#!/bin/bash

apt-get install php-xdebug -y

source /vagrant/provision/_general.sh
FILEPATH="/etc/php/$PHP_VERSION/mods-available/xdebug.ini"
XDEBUG_DIR="/var/log/xdebug"
xdebug_conf=$(cat <<-EOF

xdebug.var_display_max_data = 25000
xdebug.var_display_max_children = 1000
xdebug.var_display_max_depth = 1000
xdebug.max_nesting_level = 1000

xdebug.remote_enable = 1
xdebug.remote_connect_back = 1
xdebug.remote_host = 127.0.0.1
xdebug.remote_handler = "dbgp"
xdebug.remote_mode = "req"
xdebug.remote_port = 9000
xdebug.idekey = "$HOSTNAME"

xdebug.profiler_enable_trigger = 1
xdebug.profiler_output_dir = "$XDEBUG_DIR/profiler/"
xdebug.profiler_output_name = "%t.cachegrind.out.%p"
xdebug.trace_enable_trigger = 1
xdebug.trace_output_dir = "$XDEBUG_DIR/trace/"
xdebug.trace_output_name = "%t.trace.%c"

EOF
)

if [[ "$(cat $FILEPATH)" != *"$xdebug_conf"* ]]; then
    echo "$xdebug_conf" >> $FILEPATH
fi

mkdir -p $XDEBUG_DIR/profiler/
mkdir $XDEBUG_DIR/trace/
chown -R www-data: $XDEBUG_DIR

service php$PHP_VERSION-fpm restart

