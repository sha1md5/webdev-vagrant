#!/bin/bash

apt-get install linux-headers-$(uname -r) build-essential dkms gdebi nfs-common portmap whois htop screenfetch curl mcrypt zip unzip dos2unix ffmpeg imagemagick -y

apt-get install python-pip -y && pip install --upgrade pip
pip install speedtest-cli
curl -L https://bit.ly/glances | /bin/bash

