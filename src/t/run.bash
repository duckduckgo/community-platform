#!/bin/bash

script/ddgc_deploy_test_db.pl
cat src/t/sql/ia.sql | sqlite3 ddgc_test.db
export PIDFILE="/tmp/ddgc-$(date --iso-8601=seconds).pid"
grunt
DDGC_DB_DSN="dbi:SQLite:dbname=ddgc_test.db" plackup --host 127.0.0.1 -p 3000 -s Starman -D --pid $PIDFILE script/ddgc_dev_server.psgi
casperjs test src/t/ia/. --hostname=127.0.0.1:3000
kill $(cat $PIDFILE)
