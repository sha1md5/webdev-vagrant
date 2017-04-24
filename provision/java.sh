#!/bin/bash

add-apt-repository ppa:webupd8team/java -y
apt-get update -y
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
apt-get install oracle-java8-installer oracle-java8-set-default -y

