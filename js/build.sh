#!/bin/bash

INST="../root/static/js"

echo building $INST/ia.js

cp ia.js $INST
handlebars -f handlebars_tmp *.handlebars
cat handlebars_tmp *.js > $INST/ia.js
rm handlebars_tmp
uglifyjs $INST/ia.js -o $INST/ia.js

while getopts :rR FLAG; do
    case $FLAG in
        r) # set release number
            echo "Building release version"
            ./release.pl
            ;;
        \?) # UNKNOWN
            echo "Unknown opton $OPTARG"
            ;;
    esac
done


