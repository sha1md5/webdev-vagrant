#!/bin/bash

### Change all users passwords to usernames ###
source /vagrant/provision/_general.sh
for user in "${USERS[@]}"; do
    if [ $user != "root" ]; then
        echo "$user:$user" | chpasswd
    fi
done

### Installing Mate env. ###
apt-add-repository ppa:ubuntu-mate-dev/ppa -y
apt-add-repository ppa:ubuntu-mate-dev/xenial-mate -y
apt-get update -y
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | /usr/bin/debconf-set-selections
apt-get install "ubuntu-mate-*" "ubuntu-restricted-*" -y
echo "allowed_users=anybody" > /etc/X11/Xwrapper.config

### Install Virtualbox Guest Additions ###
DIR="/media/iso"
apt-get install "virtualbox-guest-*" -y
mkdir $DIR
mount -o loop,ro /usr/share/virtualbox/VBoxGuestAdditions.iso $DIR
sh $DIR/VBoxLinuxAdditions.run
umount $DIR
rm -rf $DIR

