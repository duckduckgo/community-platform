#!/usr/bin/env bash

SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PSGI_SCRIPT=$SCRIPTDIR/ddgc_dev_server.psgi
LIBDIR=$SCRIPTDIR/../lib
PORT=5001

[ "$DDGC_UNSUB_KEY" == "" ]          && export DDGC_UNSUB_KEY="asdfasdf"
[ "$DDGC_SHARED_SECRET" == "" ]      && export DDGC_SHARED_SECRET="asdfasdf"
[ "$DDGC_COMMENT_RATE_LIMIT" == "" ] && export DDGC_COMMENT_RATE_LIMIT=0
[ "$DDGC_DB_DSN" == "" ]             && export DDGC_DB_DSN="dbi:Pg:database=ddgc"
[ "$DDGC_DB_USER" == "" ]            && export DDGC_DB_USER="ddgc"
[ "$DBIC_TRACE_PROFILE" == "" ]      && export DBIC_TRACE_PROFILE=console
[ "$DBIC_TRACE" == "" ]              && export DBIC_TRACE=1
[ "$DANCER_ENVIRONMENT" == "" ]      && export DANCER_ENVIRONMENT=development
[ "$CATALYST_DEBUG" == "" ]          && export CATALYST_DEBUG=1

usage() {
    printf "Usage: $0 [-p port] [-m]\n" 1>&2; exit 1;
}

help() {
    printf "\nUsage: $0 [-p port] [-m] [-h]\n\n"
    printf "Options:\n\n"
    printf " -p     Specify listen port. Default: 5000\n"
    printf " -m     Use local debug mail server on port 1025\n"
    printf " -n     No Plack debug panels in rendered output\n"
    printf " -h     Show this text\n\n"
    exit 0;
}

while getopts "p:mnh" o; do
    case "${o}" in
        p)
            p=${OPTARG}
            ;;
        m)
            m=1
            ;;
        n)
            export DDGC_NO_DEBUG_PANEL=1
            ;;
        h)
            help
            ;;
        *)
            usage
            ;;
    esac
done

if [ ! -z $p ] ; then
    PORT=$p
fi

if [ "$m" == "1" ] ; then
    # python -m smtpd -n -c DebuggingServer localhost:1025
    export DDGC_SMTP_HOST="localhost:1025"
fi

plackup -R $LIBDIR -p $PORT -s Starman $PSGI_SCRIPT
