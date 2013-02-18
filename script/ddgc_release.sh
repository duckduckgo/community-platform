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

echo "*** Empty deploy directory..."
ssh -q -t ddgc@$DDGC_RELEASE_HOSTNAME "(
	rm -rf ~/deploy &&
	mkdir ~/deploy
)" && \
echo "*** Transfer release file $2..." && \
scp $2 ddgc@$DDGC_RELEASE_HOSTNAME:~/deploy && \
echo "*** Preparig release on remote site..." && \
ssh -q -t ddgc@$DDGC_RELEASE_HOSTNAME "(
	. /home/ddgc/perl5/perlbrew/etc/bashrc &&
	. /home/ddgc/ddgc_config.sh &&
	cd ~/deploy &&
	tar xz --strip-components=1 -f $2 &&
	rm $2 &&
	cpanm -n --installdeps . &&
	touch ~/ddgc_web_maintenance
)" && \
echo "*** Stopping current system..." && \
ssh -q -t root@$DDGC_RELEASE_HOSTNAME "( ~/stop_ddgc.sh )" && \
echo "*** Copying new files in place..." && \
ssh -q -t ddgc@$DDGC_RELEASE_HOSTNAME "(
	mv ~/live ~/backup/$CURRENT_DATE_FILENAME &&
	mv ~/deploy ~/live &&
	rm -rf ~/cache &&
	mkdir ~/cache &&
	cp -ar ~/live/share/docroot/* ~/docroot/
	cp -ar ~/live/share/docroot_duckpan/* ~/ddgc/duckpan/
)" && \
echo "*** Starting new system..." && \
ssh -q -t root@$DDGC_RELEASE_HOSTNAME "( svc -u /etc/service/ddgc && sleep 3 && rm /home/ddgc/ddgc_web_maintenance )" && \
echo "*** Release successful"
