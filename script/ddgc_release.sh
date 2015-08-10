#!/usr/bin/env bash

CURRENT_DATE_FILENAME=$( date +%Y%m%d_%H%M%S )

if [ "$1" = "view" ];
then
	DDGC_RELEASE_HOSTNAME="view.dukgo.com"
	DDGC_PERLBREW_SOURCE="/home/ddgc/perl5/perlbrew/etc/bashrc"
else 	if [ "$1" = "prod" ];
	then
		DDGC_RELEASE_HOSTNAME="duck.co"
		DDGC_PERLBREW_SOURCE="/etc/profile.d/perlbrew.sh"
	fi
fi

if [ -z $DDGC_RELEASE_HOSTNAME ];
then
	printf "need a release target\n"
	exit 1
fi

if [[ $2 =~ DDGC-([0-9\.]*)\. ]] ; then
	DDGC_RELEASE_VERSION=${BASH_REMATCH[1]}
fi

if [[ -z $DDGC_RELEASE_VERSION ]] ; then
	printf "Cannot extract version from tarball name, bailing...\n"
	exit -1
fi

PG_DUMP_PID=$(ssh -t ddgc@$DDGC_RELEASE_HOSTNAME "pgrep pg_dump");
if [ -n "$PG_DUMP_PID" ] ; then
	printf "************* W A R N I N G *************\n\n"
	printf "It appears a database backup is in progress\n"
	printf "This will BLOCK schema changes from deploying\n\n"
	read -p "Continue deployment [y/N]?" response
	case $response in
		[Yy]* ) break;;
		*) exit;;
	esac
fi


DDGC_RELEASE_DIRECTORY="/mnt/md0/deploy/$DDGC_RELEASE_VERSION-$CURRENT_DATE_FILENAME"

printf "\n*** Releasing DDGC $DDGC_RELEASE_VERSION to $DDGC_RELEASE_HOSTNAME...\n\n"

printf "***\n*** Creating deploy directory...\n***\n"
ssh -t ddgc@$DDGC_RELEASE_HOSTNAME "(
	if [ ! -d $DDGC_RELEASE_DIRECTORY ] ; then
		mkdir -p $DDGC_RELEASE_DIRECTORY
	fi
)" && \
printf "***\n*** Transfer release file $2...\n***\n" && \
scp $2 ddgc@$DDGC_RELEASE_HOSTNAME:$DDGC_RELEASE_DIRECTORY && \
printf "***\n*** Preparing release on remote site...\n***\n" && \
ssh -t ddgc@$DDGC_RELEASE_HOSTNAME "(
	. $DDGC_PERLBREW_SOURCE &&
	. /home/ddgc/ddgc_config.sh &&
	cd $DDGC_RELEASE_DIRECTORY &&
	tar xz --strip-components=1 -f $2 &&
	cpanm --mirror https://ddgc-pinto.duckduckgo.com --mirror-only -n --installdeps . &&
	touch ~/ddgc_web_maintenance &&
	printf Stopping current system... && 
	sudo /usr/local/sbin/stop_ddgc.sh && 
	printf Creating live installation... && 
	ln -sfn $DDGC_RELEASE_DIRECTORY ~/live
	rm -rf ~/cache &&
	mkdir ~/cache &&
	cp -ar ~/live/share/docroot/* ~/docroot/ &&
	cp -ar ~/live/share/docroot_duckpan/* ~/ddgc/duckpan/ &&
	printf Starting new system... && 
	sudo /usr/local/sbin/start_ddgc.sh
)"
