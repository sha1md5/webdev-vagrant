#!/bin/bash

add-apt-repository ppa:ondrej/php -y
apt-get update -y

apt-get install -y php$1-cli php$1-fpm php$1-bcmath php$1-bz2 php$1-curl php$1-gd \
    php$1-gmp php$1-imap php$1-intl php$1-json php$1-ldap php$1-mbstring php$1-zip \
    php$1-mcrypt php$1-mysql php$1-opcache php$1-pgsql php$1-readline php$1-recode \
    php$1-snmp php$1-sqlite3 php$1-soap php$1-tidy php$1-xml php$1-xmlrpc php$1-xsl \
    php-apcu

### Configuring all php instances - cli, fpm ###
source /vagrant/provision/_general.sh
fix_pathinfo="0"
memory_limit="256M"
expose_php="On"
max_execution_time="60"
error_reporting="E_ALL"
display_errors="On"
display_startup_errors="On"
default_charset="UTF-8"

DIR="/etc/php/$1"
FILE="php.ini"
FILEPATH="$DIR/fpm/$FILE"
sed -i "s|;cgi\.fix_pathinfo.*|cgi\.fix_pathinfo = $fix_pathinfo|g" $FILEPATH
sed -i "s|memory_limit.*|memory_limit = $memory_limit|g" $FILEPATH

instances=('cli' 'fpm')
for instance in "${instances[@]}"; do
    FILEPATH="$DIR/$instance/$FILE"
    sed -i "s|expose_php.*|expose_php = $expose_php|g" $FILEPATH
    sed -i "s|max_execution_time.*|max_execution_time = $max_execution_time|g" $FILEPATH
    sed -i "s|error_reporting.*|error_reporting = $error_reporting|g" $FILEPATH
    sed -i "s|display_errors.*|display_errors = $display_errors|g" $FILEPATH
    sed -i "s|display_startup_errors.*|display_startup_errors = $display_startup_errors|g" $FILEPATH
    sed -i "s|default_charset.*|default_charset = $default_charset|g" $FILEPATH
    sed -i "s|;date\.timezone.*|date\.timezone = $TIMEZONE|g" $FILEPATH
done

service php$1-fpm restart

