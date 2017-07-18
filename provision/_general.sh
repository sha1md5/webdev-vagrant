#!/bin/bash

HOME_DIRS=($(cat /etc/passwd | grep "/*sh$" | cut -d: -f6))
USERS=($(cat /etc/passwd | grep "/*sh$" | cut -d: -f1))
HOSTNAME=$(cat /etc/hostname)
IPS=(127.0.0.1 $(hostname -I))
TIMEZONE=$(cat /etc/timezone)
PHP_VERSION=$(php -i | grep 'PHP Version' | grep -oP "\d\.\d" | head -1)
