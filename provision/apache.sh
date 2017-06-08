#!/bin/bash

add-apt-repository ppa:ondrej/apache2 -y
apt-get update -y

apt-get install apache2 apachetop libapache2-mod-fastcgi javascript-common -y

mv /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/000-default-ssl.conf
a2ensite 000-default-ssl

modules=('fastcgi' 'alias' 'proxy' 'proxy_fcgi' 'headers' 'actions' 'rewrite' 'ssl')
for module in "${modules[@]}"
do
   a2enmod $module
done

source /vagrant/provision/_general.sh
a2enconf php$PHP_VERSION-fpm.conf

DIR="/etc/apache2"
FILEPATH="$DIR/conf-available/security.conf"

sed -i "s/ServerTokens.*/ServerTokens Full/g" $FILEPATH
sed -i "s/#Header set X-Content-Type-Options: \"nosniff\"/Header set X-Content-Type-Options: \"nosniff\"/g" $FILEPATH
sed -i "s/#Header set X-Frame-Options: \"sameorigin\"/Header set X-Frame-Options: \"sameorigin\"/g" $FILEPATH

cvs_security=$(cat <<-EOF

<DirectoryMatch "/\.(svn|git)">
    Require all denied
</DirectoryMatch>

EOF
)

if [[ "$(cat $FILEPATH)" != *"$cvs_security"* ]]; then
    echo "$cvs_security" >> $FILEPATH
fi

CHARSET="UTF-8"
sed -i "s/#AddDefaultCharset .*/AddDefaultCharset $CHARSET/g" $DIR/conf-available/charset.conf

echo "ServerName $HOSTNAME" > $DIR/conf-available/fqdn.conf
a2enconf fqdn.conf

h5ai_index="\/_h5ai\/public\/index.php"
FILEPATH="$DIR/mods-available/dir.conf"
if [[ $(grep "DirectoryIndex.*$h5ai_index" $FILEPATH) == '' ]]; then
    sed -i "s/DirectoryIndex.*$/& $h5ai_index/g" $FILEPATH
fi

FILEPATH="$DIR/apache2.conf"
sed -i '\#<Directory />#,\#</Directory># s|\(Options\) .*|\1 None|' $FILEPATH

sed -i '\#<Directory /usr/share>#,\#</Directory># d' $FILEPATH
sed -i '\#<Directory /srv/>#,\#</Directory># d' $FILEPATH

sed -i '\#<Directory /var/www/>#,\#</Directory># s|\(AllowOverride\) None|\1 All|' $FILEPATH
sed -i '\#<Directory /var/www/>#,\#</Directory># s|\(Options\) Indexes FollowSymLinks|\1 All|' $FILEPATH

FILEPATH="$DIR/ports.conf"
sed -i "s|Listen 80|Listen 81|g" $FILEPATH
sed -i "s|Listen 443|Listen 444|g" $FILEPATH

FILEPATH="$DIR/sites-available/*.conf"
sed -i "s|<VirtualHost *:80>|<VirtualHost *:81>|g" $FILEPATH
sed -i "s|<VirtualHost _default_:443>|<VirtualHost *:444>|g" $FILEPATH

### Deleting default ServerName and ServerAdmin configuration ###
grep -rl 'ServerName.*' $FILEPATH | xargs sed -i '/ServerName.*/d'
grep -rl 'ServerAlias.*' $FILEPATH | xargs sed -i '/ServerAlias.*/d'
grep -rl 'ServerAdmin.*' $FILEPATH | xargs sed -i '/ServerAdmin.*/d'

sed -i "/<VirtualHost/a     ServerName $HOSTNAME" $FILEPATH
sed -i "/ServerName/a     ServerAlias www.$HOSTNAME" $FILEPATH

service apache2 restart

cd /var/www/html/
mv index*.html test/apache2.html
chown -R www-data: /var/www/html/

