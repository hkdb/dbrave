# Dockerized Brave Browser
maintained by: hkdb <hkdb@3df.io>

![dBrave logo](dbrave-logo.png)

## SUMMARY

A dockerized instance of Brave browser running as a non-root user. Useful when "a separate sandboxed environment for testing" or "added security for browsing sites that are questionable" is needed.

## SUPPORT PLATFORMS

- GNU/Linux with Docker installed

This might work for Windows and Mac as well but needs to find a different way to connect container to host devices (snd, shm, & dri) with the docker run command adjusted.

## AUTOMATED INSTALLATION

Clone the repo and run the following interactive script from within:

```
./install.sh
```

The install script will automatically launch Brave. After you close the browser, the docker container will stop. To start this dockerized Brave browser anytime, you can just execute `docker start dbrave` or if you are a Gnome user, just search and pick "Dockerized Brave" from your launcher.

This installation script does the following:

1. Build the container image according to your host environment/user and container user password input. Note* `You are setting your password here so that you can use sudo to update the container from within later.`
2. Creates volumes for easy file access after downloading files with this browser
3. Launches containerized Brave Browser
4. Optionally install launcher shortcut for Gnome DE
   - copies icon to ~/.local/share/icons/hicolor/512x512/apps
   - copies dBrave.desktop with the proper username to ~/.local/share/applications
   - copies a script called dbrave to ~/.local/bin which really only executes `docker start dbrave`

## BUILD & RUN MANUALLY

Build:

```
docker build --build-arg USER=$USER --build-arg PASS=<password of your choice> -t local/dbrave:v0.01 .
```

Create HomeDir Volumes:

```
mkdir -p ~/Containers/dbrave/home
mkdir -p ~/Containers/dbrave/downloads
docker volume create --driver local --opt type=none --opt device=~/Containers/dbrave/home --opt o=bind dbrave-home
```

Initial Run:

```
docker run -d --name dbrave --hostname dbrave --user $USER -v dbrave-home:/home/$USER -v $HOME/Containers/dbrave/downloads:/home/$USER/Downloads -v /tmp/.X11-unix:/tmp/.X11-unix --security-opt seccomp=./brave.json -e DISPLAY=unix$DISPLAY --device /dev/dri -v /dev/shm:/dev/shm --device /dev/snd local/dbrave:v0.01
```

To launch it after you closed the initial run:

```
docker start dbrave
```

## UPDATING

You can simply update the container without rebuilding the image by executing the following:

```
$ docker exec -ti dbrave bash
$ sudo apt update
$ sudo apt upgrade
```

## CHANGE

- 02032022 - Initial commit

## REFERENCES

- SecComp Profile `brave.json` is based on: https://raw.githubusercontent.com/jfrazelle/dotfiles/master/etc/docker/seccomp/chrome.json
- Referenced this post a lot as I built this repo: https://bacchi.org/posts/brave-in-docker/

## DISCLAIMER

This repo is sponsored by 3DF OSI and is maintained by volunteers. 3DF Limited, 3DF OSI, and its volunteers including the author in no way make any guarantees. Please use at your own risk!

To Learn more, please visit:

[https://osi.3df.io](https://osi.3df.io)

[https://3df.io](https://3df.io)
