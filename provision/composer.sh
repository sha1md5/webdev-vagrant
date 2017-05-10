#!/bin/bash

curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

### Installing global composer packages ###
DIR=($(cat /etc/passwd | grep "/*sh$" | grep "1000" | cut -d: -f6))
USER=($(cat /etc/passwd | grep "/*sh$" | grep "1000" | cut -d: -f1))
mkdir -p $DIR/.composer
cd $DIR/.composer

cat <<EOF > composer.json
{
    "require": {
        "phpmd/phpmd": "@stable",
        "squizlabs/php_codesniffer": "@stable",
        "escapestudios/symfony2-coding-standard": "@stable",
        "sensiolabs/security-checker": "@stable",
        "psecio/iniscan": "@stable",
        "wimg/php-compatibility": "@stable",
        "sebastian/phpcpd": "@stable",
        "pdepend/pdepend": "@stable",
        "phploc/phploc": "@stable",
        "phpmetrics/phpmetrics": "@stable"
    },
    "config": {
        "bin-dir": "/usr/local/bin/",
        "secure-http": true
    },
    "minimum-stability": "stable",
    "prefer-stable": true
}

EOF

sudo -H -u $USER bash -c "cd $DIR/.composer/ && sudo composer update"

### Importing Symfony coding standards to phpcs ###
phpcs --config-set installed_paths $DIR/.composer/vendor/escapestudios/symfony2-coding-standard

