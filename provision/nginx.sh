#!/bin/bash

add-apt-repository ppa:ondrej/nginx-mainline -y
apt-get update -y

apt-get install nginx-extras -y

### Re/generate default snakeoil ssl certificate ###
make-ssl-cert generate-default-snakeoil --force-overwrite
### Diffie-Hellman parameters ###
openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

source /vagrant/provision/_general.sh
DIR="/etc/nginx"
WWW_DIR="/var/www/html"

### Removing default vhost configuration ###
rm $DIR/sites-available/default
rm $DIR/sites-enabled/default

### Creating general snippets ###
cat <<EOF > $DIR/snippets/secure.conf
    location ~ /\.(svn|git|ht) {
        deny all;
    }

    location / {
        try_files \$uri \$uri/ =404;
    }

    resolver 8.8.8.8 8.8.4.4;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options SAMEORIGIN;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";

EOF

cat <<EOF > $DIR/snippets/ssl.conf
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
    ssl_prefer_server_ciphers on;
    ssl_dhparam /etc/ssl/certs/dhparam.pem;
    ssl_ciphers "EECDH:+AES256:-3DES:RSA+AES:RSA+3DES:!NULL:!RC4";
    ssl_ecdh_curve secp384r1;
    ssl_session_timeout 60m;
    ssl_session_cache shared:SSL:60m;
    ssl_stapling on;
    ssl_stapling_verify on;

EOF

cat <<EOF > $DIR/snippets/php$PHP_VERSION-fpm.conf
    location ~ \.php$ {
        fastcgi_pass unix:/run/php/php$PHP_VERSION-fpm.sock;
        include snippets/fastcgi-php.conf;
        include fastcgi_params;
    }

EOF

### Creating default vhost configuration ###
cat <<EOF > $DIR/sites-available/main
server {
    listen 443 ssl default_server;
    listen [::]:443 ssl default_server;

    include snippets/snakeoil.conf;
    include snippets/ssl.conf;
    include snippets/secure.conf;
    include snippets/php$PHP_VERSION-fpm.conf;
    charset utf-8;
    autoindex on;
    root $WWW_DIR;
    server_name $HOSTNAME www.$HOSTNAME;
    index /_h5ai/public/index.php;
}

server {
    listen 80 default_server;
    listen [::]:80 default_server;

    include snippets/secure.conf;
    include snippets/php$PHP_VERSION-fpm.conf;
    charset utf-8;
    autoindex on;
    root $WWW_DIR;
    server_name $HOSTNAME www.$HOSTNAME;
    index /_h5ai/public/index.php;
}

EOF

ln -s $DIR/sites-available/main $DIR/sites-enabled/main

service nginx restart

cd $WWW_DIR
mkdir test
mv index*.html test/nginx.html
echo "<?php phpinfo();" > test/php$PHP_VERSION.php
chown -R www-data: $WWW_DIR

