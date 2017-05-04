#!/bin/bash

add-apt-repository ppa:git-core/ppa -y
add-apt-repository ppa:pdoes/gitflow-avh -y
apt-get update -y
apt-get install git git-flow -y

gitconfig=$(cat <<-EOF
[user]
    name = $1
    email = $2
[color]
    ui = true
[core]
    autocrlf = input
    safecrlf = true
    eol=lf
[credential]
    helper = cache --timeout=1800
[alias]
    Alog = log --pretty=format:\"%Cred %h (%H) %n %Cgreen Author: %an(%ae) at %ad %n %Cblue Committer: %cn(%ce) at %cd %n %Creset %B %n\" --date=format:'%A, %Y-%m-%d %H:%M:%S %z(%Z)' --graph

EOF
)

### Setting git config for all users ###
source /vagrant/provision/_general.sh
for i in "${!HOME_DIRS[@]}"; do
    echo "$gitconfig" > "${HOME_DIRS[$i]}"/.gitconfig
    chown "${USERS[$i]}": "${HOME_DIRS[$i]}"/.gitconfig
done

