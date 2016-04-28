#!/bin/bash

grunt
plackup --host 127.0.0.1 -p 3000 -s Starman -D script/ddgc_dev_server.psgi
sleep 3
curl http://127.0.0.1:3000/
casperjs test src/t/ia/. --hostname=127.0.0.1:3000
