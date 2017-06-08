#!/bin/bash

apt-get install zsh -y

FILE=".zshrc"
aliases=$(cat <<-EOF

alias su='sudo su'

alias b='cd ..'
alias c='clear'
alias e='exit'

alias la='ls -Alh --color=auto'
alias ll='ls -lh --color=auto'
alias grep='grep --color=auto'

alias untar='tar -zxvf'

alias upgradeall='sudo apt update -y && sudo apt upgrade -y && sudo apt dist-upgrade -y'
alias cleanall='sudo apt autoclean -y && sudo apt autoremove -y'

EOF
)

### Setting zsh for all users ###
source /vagrant/provision/_general.sh
for i in "${!HOME_DIRS[@]}"; do
    FILEPATH="${HOME_DIRS[$i]}/$FILE"
    
    chsh -s $(which zsh) "${USERS[$i]}"
    sudo -H -u "${USERS[$i]}" bash -c \
        'sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"'

    sed -i "s|ZSH_THEME=.*|ZSH_THEME=\"$1\"|g" $FILEPATH
    sed -i "s|plugins=.*|plugins=$2|g" $FILEPATH
    if [[ "$(cat $FILEPATH)" != *"$aliases"* ]]; then
        echo "$aliases" >> $FILEPATH
    fi
done

