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

echo "\n*** Releasing to $DDGC_RELEASE_HOSTNAME...\n"

echo "***\n*** Empty deploy directory...\n***"
ssh -q -t ddgc@$DDGC_RELEASE_HOSTNAME "(
	rm -rf ~/deploy &&
	mkdir ~/deploy
)" && \
echo "***\n*** Transfer release file $2...\n***" && \
scp $2 ddgc@$DDGC_RELEASE_HOSTNAME:~/deploy && \
echo "***\n*** Preparig release on remote site...\n***" && \
ssh -q -t ddgc@$DDGC_RELEASE_HOSTNAME "(
	. /home/ddgc/perl5/perlbrew/etc/bashrc &&
	. /home/ddgc/ddgc_config.sh &&
	cd ~/deploy &&
	tar xz --strip-components=1 -f $2 &&
	cpanm -n --installdeps . &&
	touch ~/ddgc_web_maintenance
)" && \
echo "***\n*** Stopping current system...\n***" && \
ssh -q -t root@$DDGC_RELEASE_HOSTNAME "( ~/stop_ddgc.sh )" && \
echo "***\n*** Copying new files in place...\n***" && \
ssh -q -t ddgc@$DDGC_RELEASE_HOSTNAME "(
	mv ~/live ~/backup/$CURRENT_DATE_FILENAME &&
	mv ~/deploy ~/live &&
	rm -rf ~/cache &&
	mkdir ~/cache &&
	cp -ar ~/live/share/docroot/* ~/docroot/ &&
	cp -ar ~/live/share/docroot_duckpan/* ~/ddgc/duckpan/ &&
	rm $2
)" && \
echo "***\n*** Starting new system...\n***" && \
ssh -q -t root@$DDGC_RELEASE_HOSTNAME "(
	svc -u /etc/service/ddgc &&
	sleep 10 &&
	rm /home/ddgc/ddgc_web_maintenance
)" && \
echo "***\n*** Release successful\n***"
