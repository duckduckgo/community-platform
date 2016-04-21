#!/usr/bin/env sh

cover -delete
PERL5OPT="$PERL5OPT -MDevel::Cover" prove -Ilib
cover

