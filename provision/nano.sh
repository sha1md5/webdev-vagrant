#!/bin/bash

sed -i "s/# set tabstospaces/set tabstospaces/g" /etc/nanorc
sed -i "s/# set tabsize 8/set tabsize 4/g" /etc/nanorc
sed -i "s/# set softwrap/set softwrap/g" /etc/nanorc
sed -i "s/# set fill -8/set fill -4/g" /etc/nanorc

