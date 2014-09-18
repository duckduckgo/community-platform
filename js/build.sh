#!/bin/bash

INST="../root/static/js"

echo building $INST/ia.js

handlebars -f handlebars_tmp *.handlebars
cat handlebars_tmp *.js > $INST/ia.js
rm handlebars_tmp
