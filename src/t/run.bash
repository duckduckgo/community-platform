#!/bin/bash

grunt
DDGC_DB_DSN="dbi:SQLite:dbname=ddgc_test.db" plackup --host 127.0.0.1 -p 3000 -s Starman -D script/ddgc_dev_server.psgi --workers=5
casperjs test src/t/ia/. --hostname=127.0.0.1:3000
