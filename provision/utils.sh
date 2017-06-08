#!/bin/bash

apt-get install build-essential dkms gdebi debconf-utils nfs-common portmap \
    whois htop screenfetch curl mcrypt zip unzip dos2unix ffmpeg imagemagick \
    ssl-cert apache2-utils -y

apt-get install python-pip -y && pip install --upgrade pip
pip install speedtest-cli
curl -L https://bit.ly/glances | /bin/bash

