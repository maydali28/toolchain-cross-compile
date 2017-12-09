#! /bin/bash
#setup & installation

ERROR=false
export DIR=$PWD

default_file="$DIR/scripts/default.conf"

if [ ! -e '$default_file' ] ; then
  while IFS="=" read -r key value; do
    case "$key" in
      '#'*) ;;
      *)
        eval "$key=\"$value\""
        export $key
    esac   
  done < "$default_file"
else 
	echo -e "error default file not found in $DIR/scripts"
fi

#export TAG="docker-raspberry-toolchain-new"
#export NAME="docker-raspberry-toolchain-new"

HELP_MSG="\nUsage: ./docker-RPI.sh COMMAND \
	\n\nDocker Cross compiler Manager \
	\n\nCommands \
	\n\n \
	install= Install and config docker image\
	\n \
	run= Run docker container\
	\n \
	build= Build Matrix HAL project \
	\n \
 	-h, --help= Print usage\
	 \n"

key="$1"

case $key in
	install)
	shift
	cd scripts \
	&& ./setup.sh $@ 
	exit 0
	;;
	run)
	if [ ! -z "$2" ]; then
		ERROR=true
		break
	fi
	shift
	cd scripts \
	&& ./setup.sh -r
	exit 0
	;;
	build)
	if [ ! -z "$2" ]; then
		ERROR=true
		break
	fi
	cd scripts \
	&& ./setup.sh -b
	shift
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
	echo "See './docker-RPI.sh --help' or './docker-RPI.sh -h'."
	exit 0
fi

