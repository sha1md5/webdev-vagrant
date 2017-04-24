#!/bin/bash

apt-get install ntp -y
timedatectl set-timezone $1

