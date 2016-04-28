#!/bin/bash

grunt
plackup --host 127.0.0.1 -p 3000 -s Starman -D script/ddgc_dev_server.psgi
casperjs test src/t/ia/. --hostname=127.0.0.1:3000
