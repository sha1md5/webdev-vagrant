#!/bin/bash

add-apt-repository ppa:ondrej/php -y
apt-get update -y

apt-get install -y php7.1-cli php7.1-fpm php7.1-bcmath php7.1-bz2 php7.1-curl php7.1-gd \
    php7.1-gmp php7.1-imap php7.1-intl php7.1-json php7.1-ldap php7.1-mbstring php7.1-zip \
    php7.1-mcrypt php7.1-mysql php7.1-opcache php7.1-pgsql php7.1-readline php7.1-recode \
    php7.1-snmp php7.1-sqlite3 php7.1-soap php7.1-tidy php7.1-xml php7.1-xmlrpc php7.1-xsl \
    php-apcu

### Configuring all php instances - cli, fpm ###
fix_pathinfo="0"
memory_limit="256M"
expose_php="On"
max_execution_time="60"
error_reporting="E_ALL"
display_errors="On"
display_startup_errors="On"
timezone=$(head -n 1 /etc/timezone)

DIR="/etc/php/7.1"
FILE="php.ini"

sed -i "s|;cgi\.fix_pathinfo.*|cgi\.fix_pathinfo = $fix_pathinfo|g" $DIR/fpm/$FILE
sed -i "s|memory_limit.*|memory_limit = $memory_limit|g" $DIR/fpm/$FILE

instances=("cli" "fpm")
for instance in "${instances[@]}"; do
    sed -i "s|expose_php.*|expose_php = $expose_php|g" $DIR/${instance}/$FILE
    sed -i "s|max_execution_time.*|max_execution_time = $max_execution_time|g" $DIR/${instance}/$FILE
    sed -i "s|error_reporting.*|error_reporting = $error_reporting|g" $DIR/${instance}/$FILE
    sed -i "s|display_errors.*|display_errors = $display_errors|g" $DIR/${instance}/$FILE
    sed -i "s|display_startup_errors.*|display_startup_errors = $display_startup_errors|g" $DIR/${instance}/$FILE
    sed -i "s|;date\.timezone.*|date\.timezone = $timezone|g" $DIR/${instance}/$FILE
done

service php7.1-fpm restart

