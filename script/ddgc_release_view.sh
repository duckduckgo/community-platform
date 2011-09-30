#!/bin/sh

CURRENT_DATE_FILENAME=$( date +%Y%m%d_%H%M%S )

ssh ddgcview@view.dukgo.com "(
	rm -rf ~/deploy-view &&
	mkdir ~/deploy-view
)"
scp $1 ddgcview@view.dukgo.com:~/deploy-view
ssh -t ddgcview@view.dukgo.com "(
	eval \$(perl -I\$HOME/perl5/lib/perl5 -Mlocal::lib) &&
	. ~/ddgc_config.sh &&
	cd ~/deploy-view &&
	tar xz --strip-components=1 -f $1 &&
	rm $1 &&
	cpanm --installdeps . &&
	perl Makefile.PL && make test &&
	if [ -f ~/view.web.pid ]; then
		OLDPID=\$( cat ~/view.web.pid )
	fi &&
	if [ \"\$OLDPID\" ]; then
		if [ \"\$( ps x | cut -c1-5 | grep \$OLDPID )\" ]; then
			kill \$OLDPID &&
			sleep 2 &&
			if [ \"\$( ps x | cut -c1-5 | grep \$OLDPID )\" ]; then
				kill -9 \$OLDPID &&
				sleep 2 &&
				if [ \"\$( ps x | cut -c1-5 | grep \$OLDPID )\" ]; then
					ps x | mail getty@duckduckgo.com -s \"[DDGC] Old view server still running (\$OLDPID)\"
				fi;
			fi;
		fi;
	fi &&
	mv ~/view ~/backup/view-$CURRENT_DATE_FILENAME &&
	mv ~/deploy-view ~/view &&
	rm -rf ~/cache-view &&
	mkdir ~/cache-view &&
	perl ~/view/script/ddgc_db_autoupgrade.pl &&
	perl ~/view/script/ddgc_web_fastcgi.pl --listen ~/view.web.socket -d -p ~/view.web.pid
)"
