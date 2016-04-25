#!/bin/sh

if [ $(hostname) ]
then
    HOSTNAME=$(hostname)
else 
    HOSTNAME='ddgc-staging'
fi

casperjs test src/t/ia/. --hostname="$HOSTNAME"
