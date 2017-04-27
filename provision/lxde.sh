#!/bin/bash

### Change all users passwords to usernames ###
source /vagrant/provision/_general.sh
for i in "${!USERS[@]}"; do
    if [ "${USERS[$i]}" != "root" ]; then
        echo "${USERS[$i]}:${USERS[$i]}" | chpasswd
    fi
done

### Installing LXDE ###
apt-get install --no-install-recommends lubuntu-core lubuntu-desktop -y
echo "allowed_users=anybody" > /etc/X11/Xwrapper.config

### Install Virtualbox Guest Additions ###
apt-get install "virtualbox-guest-*" -y
mkdir /media/iso
mount -o loop,ro /usr/share/virtualbox/VBoxGuestAdditions.iso /media/iso
sh /media/iso/VBoxLinuxAdditions.run
umount /media/iso
rm -rf /media/iso

