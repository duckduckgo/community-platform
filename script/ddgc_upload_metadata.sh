#!/usr/bin/env bash

FORCE_UPLOAD=0
[ -n "$1" ] && \
  FORCE_UPLOAD=1
[ "$DDGC_REPO_JSON_OUT" == "" ]   && \
  export DDGC_REPO_JSON_OUT='/home/ddgc/ddgc/repo_all.json'
[ "$DDGC_REPO_JSON_URL" == "" ]   && \
  export DDGC_REPO_JSON_URL='https://duck.co/ia/repo/all/json'
[ "$DDGC_REPO_JSON_S3URL" == "" ] && \
  export DDGC_REPO_JSON_S3URL='s3://ddg-community/metadata/repo_all.json.bz2'
DDGC_REPO_BZIP2_OUT="$DDGC_REPO_JSON_OUT.bz2"
DDGC_REPO_JSON_S3URL_TMP="$DDGC_REPO_JSON_S3URL.$(date +%s)"

[ $FORCE_UPLOAD -eq 1 ] && [ -f $DDGC_REPO_JSON_OUT ] && rm $DDGC_REPO_JSON_OUT
LAST_MODIFIED_TIME=0
if [ -f $DDGC_REPO_JSON_OUT ]
then
  LAST_MODIFIED_TIME=$(/usr/bin/stat --format=%Y $DDGC_REPO_JSON_OUT)
fi

perl -MLWP::Simple -e "if ((mirror\"$DDGC_REPO_JSON_URL\", \"$DDGC_REPO_JSON_OUT\") < 400) { exit 0; } else { exit 1; }"
DOWNLOAD_EXIT_CODE=$?
NEW_MODIFIED_TIME=0
[ $DOWNLOAD_EXIT_CODE -eq 0 ] && [ -f $DDGC_REPO_JSON_OUT ] && \
  NEW_MODIFIED_TIME=$(/usr/bin/stat --format=%Y $DDGC_REPO_JSON_OUT)

if [[ ( $DOWNLOAD_EXIT_CODE -eq 0 && $NEW_MODIFIED_TIME -gt $LAST_MODIFIED_TIME ) || ( $DOWNLOAD_EXIT_CODE -eq 0 && $FORCE_UPLOAD -eq 1 ) ]] ; then
  json_xs < $DDGC_REPO_JSON_OUT > /dev/null
  if [ "$?" == "0" ] ; then
    bzip2 --best --force --keep $DDGC_REPO_JSON_OUT
    if [ "$?" == "0" ] ; then
      bzip2 -t $DDGC_REPO_BZIP2_OUT
      if [ "$?" == "0" ] ; then
        s3cmd -P -m 'application/x-bzip2' --add-header='Content-Encoding: bzip2' --force -c /usr/local/etc/s3cmd/ddgc-metadata.s3cfg put $DDGC_REPO_BZIP2_OUT $DDGC_REPO_JSON_S3URL_TMP > /dev/null
        if [ "$?" == "0" ] ; then
          s3cmd --force -c /usr/local/etc/s3cmd/ddgc-metadata.s3cfg mv $DDGC_REPO_JSON_S3URL_TMP $DDGC_REPO_JSON_S3URL > /dev/null
        fi
      fi
    fi
  fi
fi

