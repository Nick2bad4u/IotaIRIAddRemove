#!/bin/bash

#stop nelson in pm2

echo Stopping nelson...

sudo pm2 stop nelson

echo Nelson stopped to avoid conflicts or bugs...

# Ask for server name/ip

echo Please enter Server to ADD with TCP or UDP. Ex: tcp://192.168.0.1:15600 or udp://192.168.0.1:14600

read server

echo The server you entered to be added is: $server

# Ask if sure you want to add

read -p "Are you sure you want to add $server (y/n)?" choice
case "$choice" in 
  y|Y ) echo "yes";;
  n|N ) echo "no";;
  * ) echo "invalid";;
esac

if [[ ! $choice =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

#add via API command locally

curl -H 'X-IOTA-API-VERSION: 1.4' -d '{"command":"addNeighbors", "uris":["'"$server"'"]}' http://localhost:14265

echo $server has been added via API...

# Ask to add to config

read -p "Would you like to add $server via config? (This adds it forever(y/n)?" choice3

case "$choice3" in 
  y|Y ) echo "yes";;
  n|N ) echo "no";;
  * ) echo "invalid";;
esac

if [[ ! $choice3 =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

#add to config

sed -i "14s|$| $server|" /home/iota/node/iota.ini

echo Adding $server in the config file...

echo $server has been added forever!

echo done.

#ask to view config

read -p "Would you like to see your config file to verify?(y/n)" choice2
case "$choice2" in 
  y|Y ) echo "yes";;
  n|N ) echo "no";;
  * ) echo "invalid";;
esac

if [[ ! $choice =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

#show config

cat /home/iota/node/iota.ini

#start nelson in pm2

echo Starting nelson...

sudo pm2 start nelson

echo Nelson started...

#end