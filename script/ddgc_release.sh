#!/bin/sh

CURRENT_DATE_FILENAME=$( date +%Y%m%d_%H%M%S )

if [ "$1" = "view" ];
then
	DDGC_RELEASE_HOSTNAME="view.dukgo.com"
else 	if [ "$1" = "prod" ];
	then
		DDGC_RELEASE_HOSTNAME="dukgo.com"
	fi
fi

if [ "$DDGC_RELEASE_HOSTNAME" = "" ];
then
	echo "need a release target"
	exit 1
fi

echo "Releasing to $DDGC_RELEASE_HOSTNAME..."

ssh -q -t ddgc@$DDGC_RELEASE_HOSTNAME "(
	rm -rf ~/deploy &&
	mkdir ~/deploy
)" && \
scp $2 ddgc@$DDGC_RELEASE_HOSTNAME:~/deploy && \
ssh -q -t ddgc@$DDGC_RELEASE_HOSTNAME "(
	eval \$(perl -I\$HOME/perl5/lib/perl5 -Mlocal::lib) &&
	. ~/ddgc_config.sh &&
	cd ~/deploy &&
	tar xz --strip-components=1 -f $2 &&
	rm $2 &&
	cpanm -n --installdeps . &&
	touch ~/ddgc_web_maintenance
)" && \
ssh -q -t root@$DDGC_RELEASE_HOSTNAME "( svc -d /etc/service/ddgc )" && \
ssh -q -t ddgc@$DDGC_RELEASE_HOSTNAME "(
	mv ~/live ~/backup/$CURRENT_DATE_FILENAME &&
	mv ~/deploy ~/live &&
	rm -rf ~/cache &&
	mkdir ~/cache &&
	cp -ar ~/live/share/docroot/* ~/docroot/
)" && \
ssh -q -t root@view.dukgo.com "( svc -u /etc/service/ddgc && rm /home/ddgc/ddgc_web_maintenance )" && \
echo "Release successful"
