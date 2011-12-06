#!/bin/sh

CURRENT_DATE_FILENAME=$( date +%Y%m%d_%H%M%S )

ssh ddgc@view.dukgo.com "(
	rm -rf ~/deploy &&
	mkdir ~/deploy
)"
scp $1 ddgc@view.dukgo.com:~/deploy
ssh -t ddgc@view.dukgo.com "(
	eval \$(perl -I\$HOME/perl5/lib/perl5 -Mlocal::lib) &&
	. ~/ddgc_config.sh &&
	cd ~/deploy &&
	tar xz --strip-components=1 -f $1 &&
	rm $1 &&
	cpanm -n --installdeps . &&
	touch ~/ddgc_web_maintenance &&
	if [ -f ~/web.pid ]; then
		OLDPID=\$( cat ~/web.pid )
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
	# probably adding check for database in sync
	mv ~/live ~/backup/$CURRENT_DATE_FILENAME &&
	mv ~/deploy ~/live &&
	rm -rf ~/cache &&
	mkdir ~/cache &&
	. ~/ddgc_config.sh &&
	# replace against check above
	#perl ~/live/script/ddgc_db_autoupgrade.pl &&
	perl ~/live/script/ddgc_web_fastcgi.pl --listen 127.0.0.1:8989 -d -p ~/web.pid &&
	rm ~/ddgc_web_maintenance
)"
