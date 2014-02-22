#!/bin/sh

CURRENT_DATE_FILENAME=$( date +%Y%m%d_%H%M%S )

if [ "$1" = "view" ];
then
	DDGC_RELEASE_HOSTNAME="view.dukgo.com"
else 	if [ "$1" = "prod" ];
	then
		DDGC_RELEASE_HOSTNAME="duck.co"
	fi
fi

if [ "$DDGC_RELEASE_HOSTNAME" = "" ];
then
	echo "need a release target"
	exit 1
fi

echo "\n*** Releasing to $DDGC_RELEASE_HOSTNAME...\n"

echo "***\n*** Empty deploy directory...\n***"
ssh -t ddgc@$DDGC_RELEASE_HOSTNAME "(
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
	duckpan DDGC::Static &&
	touch ~/ddgc_web_maintenance &&
	echo Stopping current system... && 
	sudo /usr/local/sbin/stop_ddgc.sh && 
	echo Copying new files in place... && 
	. /home/ddgc/perl5/perlbrew/etc/bashrc &&
	. /home/ddgc/ddgc_config.sh &&
	mv ~/live ~/backup/$CURRENT_DATE_FILENAME &&
	mv ~/deploy ~/live &&
	rm -rf ~/cache &&
	mkdir ~/cache &&
	cp -ar ~/live/share/docroot/* ~/docroot/ &&
	cp -ar ~/live/share/docroot_duckpan/* ~/ddgc/duckpan/ &&
	echo Starting new system... && 
	sudo /usr/local/sbin/start_ddgc.sh &&
	. /home/ddgc/perl5/perlbrew/etc/bashrc &&
	. /home/ddgc/ddgc_config.sh &&
	cd ~/live &&
	script/ddgc_add_duckpan_dist.pl ddgc $2
)"
