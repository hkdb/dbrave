#!/bin/bash

##
## dBrave  short cut for dbrave_ubuntu container
##

## maintained by: hkdb <hkdb@3df.io>

echo -e "\n"
read -sp 'Enter a password for your container user: ' DBRAVE_PASS


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
   sed 's|HOME|'$HOME'|g' dbrave_ubuntu.desktop.skel > dbrave_ubuntu.desktop
   mv dbrave_ubuntu.desktop $HOME/.local/share/applications/
   cp dbrave_ubuntu $HOME/.local/bin/
elif [ "$GL" = "N" ] || [ "$GL" = "n" ]; then 
   echo -e "\nSkipping installation of Gnome launcher shortcut...\n"
else
   echo -e "\nUnrecognized input, skipping installation of Gnome launcher shortcut...\n"
fi

echo -e "\nDone... exiting...\n"
