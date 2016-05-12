#!/bin/bash

export USERPAGE_OUT="${HOME}/ddgc/test-ddh-userpages"
export SKIP_GENERATE=1
if [ ! -d "${USERPAGE_OUT}" ] ;  then
    exit -1;
fi

export PIDFILE="/tmp/up-$(date --iso-8601=seconds).pid"
plackup --host 127.0.0.1 -p 3001 -s Starman -D --pid $PIDFILE bin/dev_server.psgi
# Add userpage tests here:
# casperjs test src/t/up/. --hostname=127.0.0.1:3001
kill $(cat $PIDFILE)
