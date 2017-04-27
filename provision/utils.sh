#!/bin/bash

### Setting additional extras ###
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | /usr/bin/debconf-set-selections
apt-get install ubuntu-restricted-extras build-essential linux-headers-$(uname -r) -y

### Installing additional libs ###
apt-get install nfs-common portmap -y
apt-get install curl mcrypt -y
apt-get install gdebi dkms -y
apt-get install ffmpeg imagemagick -y
apt-get install whois htop screenfetch -y
apt-get install zip unzip -y
apt-get install dos2unix -y
apt-get install python-pip -y && pip install --upgrade pip
pip install speedtest-cli
curl -L https://bit.ly/glances | /bin/bash

