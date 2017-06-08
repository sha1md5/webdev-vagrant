#!/bin/bash

echo $1 > /etc/hostname

source /vagrant/provision/_general.sh
if [[ $(grep "127.0.0.1.*$1" /etc/hosts) == '' ]]; then
    sed -i "s/127.0.0.1.*$/& $1/g" /etc/hosts
fi

