#!/bin/bash

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - 
sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
add-apt-repository ppa:webupd8team/atom -y
apt-get update -y


apt-get install google-chrome-stable -y
apt-get install terminator -y
apt-get install mysql-workbench -y
apt-get install atom -y

wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
sudo dpkg -i gitkraken-amd64.deb
rm -f gitkraken-amd64.deb

