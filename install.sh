#!/bin/bash

##
## dBrave Installation Script
##

## maintained by: hkdb <hkdb@3df.io>

echo -e "\n"
read -sp 'Enter a password for your container user: ' DBRAVE_PASS

echo -e "\nBuilding container image..."
docker build --build-arg USER=$USER --build-arg PASS=$DBRAVE_PASS --rm -t local/dbrave:v0.01 .

read -p 'Where do you want the container HOME volume to be? (press enter for default: ~/Containers/dbrave/home): ' DBRAVE_HOME
if [ "$DBRAVE_HOME" = "" ]; then
   DBRAVE_HOME="$HOME/Containers/dbrave/home"
fi
echo -e "\nCreating $DBRAVE_HOME...\n"
mkdir -p $DBRAVE_HOME

read -p 'Where do you want the container Downloads volume to be? (press enter for default: ~/Containers/dbrave/downloads): ' DBRAVE_DL
if [ "$DBRAVE_DL" = "" ]; then
   DBRAVE_DL="$HOME/Containers/dbrave/downloads"
fi
echo -e "\nCreating $DBRAVE_DL... Files you download from this Brave instance will reside here...\n"
mkdir -p $DBRAVE_DL

if [ "$(docker volume ls -f name=$1 | awk '{print $NF}' | grep 'dbrave-home')" ]; then
   echo -e "\nVolume dbrave-home already exists. Skipping creation...\n"
else
   echo -e "\nCreating docker volume for dbrave homedir...\n"
   docker volume create --driver local --opt type=none --opt device=$DBRAVE_HOME --opt o=bind dbrave-home
fi

echo -e "\nLaunching container...\n"
docker run -d --name dbrave --hostname dbrave --user $USER --dns="1.1.1.1" --cap-add=NET_ADMIN --device=/dev/net/tun -v dbrave-home:/home/$USER -v $DBRAVE_DL:/home/$USER/Downloads -v /tmp/.X11-unix:/tmp/.X11-unix --security-opt seccomp=./brave.json -e DISPLAY=unix$DISPLAY --device /dev/dri -v /dev/shm:/dev/shm --device /dev/snd local/dbrave:v0.01

echo -e "\nCompleted... If all went well, you should see a Brave browser popping up. To launch it again after you close it, simply type \"docker start dbrave\"...\n"

echo -e "\n"
read -p 'Would you like to add a shortcut to Gnome Launcher? (Y/n): ' GL

if [ "$GL" = "Y" ] || [ "$GL" = "y" ] || [ "$GL" = "" ]; then
   echo -e "\nInstalling Gnome launcher shortcut...\n"
  
   if [ ! -d "$HOME/.local/share/icons/hicolor/512x512/apps" ]; then
      mkdir -p $HOME/.local/share/icons/hicolor/512x512/apps
   fi

   if [ ! -d "$HOME/.local/share/applications" ]; then
      mkdir -p $HOME/.local/share/applications
   fi
   
   if [ ! -d "$HOME/.local/bin" ]; then
      mkdir -p $HOME/.local/bin
   fi
   cp dbrave-logo.png $HOME/.local/share/icons/hicolor/512x512/apps/
   sed 's|HOME|'$HOME'|g' dBrave.desktop.skel > dBrave.desktop
   mv dBrave.desktop $HOME/.local/share/applications/
   cp dbrave $HOME/.local/bin/
elif [ "$GL" = "N" ] || [ "$GL" = "n" ]; then 
   echo -e "\nSkipping installation of Gnome launcher shortcut...\n"
else
   echo -e "\nUnrecognized input, skipping installation of Gnome launcher shortcut...\n"
fi

echo -e "\nDone... exiting...\n"
