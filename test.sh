#!/bin/bash

##
## 
##

## maintained by: hkdb <hkdb@3df.io>
echo "hiii $1"


echo -e "\n"
read -p 'Enter  container name (eg: dbrave-spring ): ' CONTAINER_NAME
export HOME="ubbe"
sed  's|HOME|'$HOME'|g; s|BRAVED|'$CONTAINER_NAME'|g'  dBrave.desktop.skel > $CONTAINER_NAME.desktop

echo -e "\n"
read -p 'Would you like to add a shortcut to Gnome Launcher? (Y/n): ' GL


git reset --hard && git clean -df &&  git pull

##testing
