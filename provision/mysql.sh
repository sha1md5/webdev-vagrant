#!/bin/bash

DEBCONF_PREFIX="mysql-apt-config mysql-apt-config"

### Installing MySQL APT Repository ###
curl -L -o mysql-apt-config.deb https://dev.mysql.com/get/mysql-apt-config_0.8.5-1_all.deb

debconf-set-selections <<< "$DEBCONF_PREFIX/repo-codename select xenial"
debconf-set-selections <<< "$DEBCONF_PREFIX/repo-distro select ubuntu"
debconf-set-selections <<< "$DEBCONF_PREFIX/unsupported-platform select abort"
debconf-set-selections <<< "$DEBCONF_PREFIX/repo-url string http://repo.mysql.com/apt"
debconf-set-selections <<< "$DEBCONF_PREFIX/select-server select mysql-5.7"
debconf-set-selections <<< "$DEBCONF_PREFIX/select-preview select Disabled"
debconf-set-selections <<< "$DEBCONF_PREFIX/select-tools select Enabled"
debconf-set-selections <<< "$DEBCONF_PREFIX/tools-component string mysql-tools"
debconf-set-selections <<< "$DEBCONF_PREFIX/select-product select Ok"

export DEBIAN_FRONTEND=noninteractive
dpkg -i mysql-apt-config.deb
apt-get -fy install
rm -f mysql-apt-config.deb
apt-get update -y

### Defining temporary default password for root@localhost user ###
tempPassword="temp"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $tempPassword"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $tempPassword"

apt-get install mysql-client mysql-server mysqltuner -y

curl -L -o mysql-workbench-community.deb https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-6.3.9-1ubuntu16.04-amd64.deb
curl -L -o mysql-utilities.deb https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-utilities_1.6.5-1ubuntu16.04_all.deb

PACKAGES=("mysql-workbench-community.deb" "mysql-utilities.deb")
for i in "${!PACKAGES[@]}"
do
   dpkg -i "${PACKAGES[$i]}"
   apt-get -fy install
   rm -f "${PACKAGES[$i]}"
done

pip install mycli

# mysqld --initialize # mysql_install_db
# mysql_secure_installation

### Setting all charsets to utf8mb4 and collation to utf8mb4_unicode_ci ###
FILEPATH="/etc/mysql/"
COLLATION="utf8mb4_unicode_ci"
CHARACTER_SET="utf8mb4"

grep -rl '\[client\]' $FILEPATH | xargs sed -i "/\[client\]/a default-character-set=$CHARACTER_SET"
grep -rl '\[mysql\]' $FILEPATH | xargs sed -i "/\[mysql\]/a default-character-set=$CHARACTER_SET"
grep -rl '\[mysqldump\]' $FILEPATH | xargs sed -i "/\[mysqldump\]/a default-character-set=$CHARACTER_SET"
grep -rl '\[mysqld\]' $FILEPATH | xargs sed -i "/\[mysqld\]/a character-set-server=$CHARACTER_SET"
grep -rl '\[mysqld\]' $FILEPATH | xargs sed -i "/\[mysqld\]/a init-connect='SET NAMES $CHARACTER_SET'"
grep -rl '\[mysqld\]' $FILEPATH | xargs sed -i "/\[mysqld\]/a init_connect='SET collation_connection=$COLLATION'"
grep -rl '\[mysqld\]' $FILEPATH | xargs sed -i "/\[mysqld\]/a collation-server=$COLLATION"
grep -rl '\[mysqld\]' $FILEPATH | xargs sed -i "/\[mysqld\]/a skip-character-set-client-handshake"

### Creating root@% without password and deleting root@localhost users ###
mysql -uroot -p$tempPassword -e "CREATE USER 'root'@'%' IDENTIFIED BY '';"
mysql -uroot -p$tempPassword -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;"
mysql -uroot -p$tempPassword -e "DROP USER 'root'@'localhost';"

service mysql restart

