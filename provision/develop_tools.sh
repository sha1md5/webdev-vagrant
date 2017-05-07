#!/bin/bash

add-apt-repository ppa:gnome-terminator -y
apt-get update -y
apt-get install terminator -y

curl -L -o google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
curl -L -o atom.deb https://atom.io/download/deb
curl -L -o gitkraken.deb https://release.gitkraken.com/linux/gitkraken-amd64.deb

PACKAGES=("google-chrome.deb" "atom.deb" "gitkraken.deb")
for i in "${!PACKAGES[@]}"
do
   dpkg -i "${PACKAGES[$i]}"
   apt-get -fy install
   rm -f "${PACKAGES[$i]}"
done

