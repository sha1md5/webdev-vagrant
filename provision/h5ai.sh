#!/bin/bash

cd /var/www/html/
FILE="h5ai-0.29.0.zip"
wget https://release.larsjung.de/h5ai/$FILE
unzip $FILE
rm $FILE
chown -R www-data: _h5ai/

FILEPATH="/var/www/html/_h5ai/private/conf/options.json"

### View section ###
LINE="/\"view\": {/,/},/{/\"view\": {/n;/},/"
sed -i "$LINE!{s/\"binaryPrefix\":.*,/\"binaryPrefix\": true,/g}}" $FILEPATH
sed -i "$LINE!{s/\"modeToggle\":.*,/\"modeToggle\": true,/g}}" $FILEPATH
sed -i "$LINE!{s/\"unmanaged\":.*,/\"unmanaged\": \[\],/g}}" $FILEPATH
sed -i "$LINE!{s/\"unmanagedInNewWindow\":.*/\"unmanagedInNewWindow\": true/g}}" $FILEPATH

### Folder size Section ###
LINE="/\"foldersize\": {/,/},/{/\"foldersize\": {/n;/},/"
sed -i "$LINE!{s/\"enabled\":.*,/\"enabled\": true,/g}}" $FILEPATH
sed -i "$LINE!{s/\"type\":.*/\"type\": \"shell-du\"/g}}" $FILEPATH

### Info Section ###
LINE="/\"info\": {/,/},/{/\"info\": {/n;/},/"
sed -i "$LINE!{s/\"enabled\":.*,/\"enabled\": true,/g}}" $FILEPATH
sed -i "$LINE!{s/\"show\":.*,/\"show\": true,/g}}" $FILEPATH

