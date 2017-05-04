#!/bin/bash

### Change all users passwords to usernames ###
source /vagrant/provision/_general.sh
for i in "${!USERS[@]}"; do
    if [ "${USERS[$i]}" != "root" ]; then
        echo "${USERS[$i]}:${USERS[$i]}" | chpasswd
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
apt-get install "virtualbox-guest-*" -y
mkdir /media/iso
mount -o loop,ro /usr/share/virtualbox/VBoxGuestAdditions.iso /media/iso
sh /media/iso/VBoxLinuxAdditions.run
umount /media/iso
rm -rf /media/iso

