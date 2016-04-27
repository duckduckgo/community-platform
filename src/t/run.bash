#!/bin/bash
source /etc/profile.d/perlbrew.sh
plackup -p 3000 -s Starman -D /home/ddgc/community-platform/script/ddgc_dev_server.psgi
casperjs test src/t/ia/. --hostname=localhost:3000
