#!/bin/bash

#stop nelson in pm2

echo Stopping nelson...

sudo pm2 stop nelson

echo Nelson stopped to avoid conflicts or bugs...

# Ask for server name/ip

echo Please enter Server to REMOVE with TCP or UDP. Ex: tcp://192.168.0.1:15600 or udp://192.168.0.1:14600

read server

echo The server you entered to be removed is: $server

# Ask if sure you want to remove

read -p "Are you sure you want to remove $server (y/n)?" choice
case "$choice" in 
  y|Y ) echo "yes";;
  n|N ) echo "no";;
  * ) echo "invalid";;
esac

if [[ ! $choice =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

#remove via API command locally

curl -H 'X-IOTA-API-VERSION: 1.4' -d '{"command":"removeNeighbors", "uris":["'"$server"'"]}' http://localhost:14265

echo $server has been removed via API...

# Ask to remove from config

read -p "Would you like to remove $server via config? (This deletes it forever(y/n)?" choice3

case "$choice3" in 
  y|Y ) echo "yes";;
  n|N ) echo "no";;
  * ) echo "invalid";;
esac

if [[ ! $choice3 =~ ^[Yy]$ ]]
then
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

#delete from config

sed -i "s/ $server\>//g" /home/iota/node/iota.ini

echo Removing $server in the config file...

echo $server has been removed forever!

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