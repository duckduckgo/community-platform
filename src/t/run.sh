#!/bin/sh

if [ $(hostname) ]
then
    HOSTNAME=$(hostname)
else 
    HOSTNAME='ddgc-staging'
fi

plackup -p 3000 -s Starman -D script/ddgc_dev_server.psgi
casperjs test src/t/ia/. --hostname="$HOSTNAME"
