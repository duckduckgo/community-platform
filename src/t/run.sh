#!/bin/sh

plackup -p 3000 -s Starman -D script/ddgc_dev_server.psgi
casperjs test src/t/ia/. --hostname=localhost:3000
