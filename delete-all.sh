#!/bin/bash


docker container ls --format "{{.Names}}"

echo -e "\n"
read -p 'Enter  container name (eg: dbrave-spring ): ' CONTAINER_NAME


docker rm $CONTAINER_NAME\


rm -rf $HOME/.local/bin/$CONTAINER_NAME

rm -rf  $HOME/.local/share/applications/$CONTAINER_NAME.desktop

rm -rf ~/.local/share/applications/$CONTAINER_NAME.desktop

rm -rf  ~/.local/bin/$CONTAINER_NAME


