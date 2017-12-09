#! /bin/bash
#setup & installation

HELP_MSG="\nUsage: ./syncRpi.sh COMMAND \
	\n\sync docker RPI Manager \
	\n\nCommands \
	\n\n \
	-r, --rsync= sync sysroot file system from RPI using ip address\n \
 	-h, --help= Print usage \n \
    -s, --send= send compiled files to RPI using ip address \
	\n"

IP=""
B_IP=false
B_SEND=false
ERROR=false

key="$1"

case $key in
	-r|--rsync)
    if [[ -z $2 ]] || [[ $2 == *"-"* ]]; then
		ERROR=true
	fi
	IP="$2"
    B_IP=true
	;;
    -s|--send)
    if [[ -z $2 ]] || [[ $2 == *"-"* ]]; then
		ERROR=true
	fi
	IP="$2"
    B_SEND=true
	;;
	-h|--help)
	echo -e ${HELP_MSG}
	exit 0
	;;
	*)
	ERROR=true
	;;
esac

if [[ ${ERROR} == true ]]; then
    echo "See './syncRpi.sh --help' or './syncRpi.sh -h'."
    exit 0
fi

if [[ ${B_IP} == true ]]; then
    #TODO verif IP 
    rsync -rl --delete-after --safe-links -e ssh pi@${IP}:/{lib,usr} $SYSROOT_PATH/
fi

if [[ ${B_SEND} == true ]]; then
    #TODO verif IP
    if [ ! -d "${WORKSPACE}/matrix-creator-hal/build" ]; then
			echo "folder ${WORKSPACE}/matrix-creator-hal/build not found"
			exit 0
	fi
    scp -r ${WORKSPACE}/matrix/matrix-creator-hal/build pi@${IP}:/home/pi/ 
fi
