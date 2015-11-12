#!/usr/bin/env bash

[ "$DDGC_REPO_JSON_OUT" == "" ]   && \
    export DDGC_REPO_JSON_OUT='/home/ddgc/ddgc/repo_all.json'
[ "$DDGC_REPO_JSON_URL" == "" ]   && \
    export DDGC_REPO_JSON_URL='https://duck.co/ia/repo/all/json'
[ "$DDGC_REPO_JSON_S3URL" == "" ] && \
    export DDGC_REPO_JSON_S3URL='s3://ddg-community/metadata/repo_all.json.bz2'
DDGC_REPO_BZIP2_OUT="$DDGC_REPO_JSON_OUT.bz2"

CURL_CMD="
    curl $DDGC_REPO_JSON_URL \
    --create-dirs \
    --output $DDGC_REPO_JSON_OUT \
    --location \
    --silent \
"

if [ -f $DDGC_REPO_JSON_OUT ] ; then
    # Only re-download if-modified-since file's mtime
    CURL_CMD="$CURL_CMD --time-cond $DDGC_REPO_JSON_OUT"
fi

$CURL_CMD
if [ "$?" == "0" ] ; then
    bzip2 --best --force --keep $DDGC_REPO_JSON_OUT
    [ "$?" == "0" ] && \
        s3cmd -P -m 'application/x-bzip2' --add-header='Content-Encoding: bzip2' --force put $DDGC_REPO_BZIP2_OUT $DDGC_REPO_JSON_S3URL > /dev/null
fi
