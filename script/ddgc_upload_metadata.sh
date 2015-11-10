#!/usr/bin/env bash

[ "$DDGC_REPO_JSON_OUT" == "" ]   && \
    export DDGC_REPO_JSON_OUT='/home/ddgc/ddgc/repo_all.json'
[ "$DDGC_REPO_JSON_URL" == "" ]   && \
    export DDGC_REPO_JSON_URL='https://duck.co/ia/repo/all/json'
[ "$DDGC_REPO_JSON_S3URL" == "" ] && \
    export DDGC_REPO_JSON_S3URL='s3://ddg-community/metadata/repo_all.json'

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
    s3cmd put --force $DDGC_REPO_JSON_OUT $DDGC_REPO_JSON_S3URL > /dev/null
    s3cmd setacl --acl-public $DDGC_REPO_JSON_S3URL > /dev/null
fi

