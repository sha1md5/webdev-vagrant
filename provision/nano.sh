#!/bin/bash

FILEPATH="/etc/nanorc"

sed -i "s/# set tabstospaces/set tabstospaces/g" $FILEPATH
sed -i "s/# set tabsize 8/set tabsize 4/g" $FILEPATH
sed -i "s/# set softwrap/set softwrap/g" $FILEPATH
sed -i "s/# set fill -8/set fill -4/g" $FILEPATH

