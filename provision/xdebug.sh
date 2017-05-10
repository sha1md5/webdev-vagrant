#!/bin/bash

apt-get install php-xdebug -y

cat <<EOF >> /etc/php/7.1/mods-available/xdebug.ini

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
xdebug.idekey = "$1"

xdebug.profiler_enable_trigger = 1
xdebug.profiler_output_dir = "/var/log/xdebug/profiler/"
xdebug.profiler_output_name = "%t.cachegrind.out.%p"
xdebug.trace_enable_trigger = 1
xdebug.trace_output_dir = "/var/log/xdebug/trace/"
xdebug.trace_output_name = "%t.trace.%c"

EOF

mkdir -p /var/log/xdebug/profiler/
mkdir /var/log/xdebug/trace/
chown -R www-data: /var/log/xdebug/

service php7.1-fpm restart

