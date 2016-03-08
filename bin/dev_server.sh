#!/usr/bin/env bash

SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" 1>/dev/null && pwd )
PORT=5002

while getopts "p:" o; do
    case "${o}" in
        p)
            p=${OPTARG}
            ;;
    esac
done

if [ ! -z $p ] ; then
    PORT=$p
fi

plackup -p $PORT -s Starman $SCRIPTDIR/dev_server.psgi
