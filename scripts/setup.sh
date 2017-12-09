#! /bin/bash
#setup & installation

export TOOLCHAIN="$DIR/toolchain"

BUILD=flase
ERROR=false
HELP_MSG="\nUsage: ./setup.sh [-tnV] arg [-rbH] \
	\n\nInstall docker and configure Matrix HAL \
	\n\nOptions \
	\n\n \
	-t, --tag= Name and optionally a tag in the 'name:tag' format \
	\n \
	-n, --name= Assign a name to the container \
	\n \
	-V, --volume= Bind mount a volume [use Absolute path]\
	\n \
	-b, --build= Build an image from a Dockerfile \
	\n \
 	-r, --run= Run a command in a new container \
	 \n \
        -h, --help= Print usage"


while [[ $# -gt 0 ]]; do
key="$1"

if [[ ${ERROR} == true ]]; then
	echo "See './setup.sh --help' or './setup.sh -h'."
	exit 0
fi

case $key in
	-t|--tag)
	if [[ -z $2 ]] || [[ $2 == *"-"* ]]; then
		ERROR=true
	fi
	TAG="$2"
	shift 2
	;;
	-n|--name)
	if [[ -z $2 ]] || [[ $2 == *"-"* ]]; then
		ERROR=true
	fi
	NAME="$2"
	shift 2
	;;
	-V|--volume)
	if [[ -z $2 ]] || [[ $2 == *"-"* ]]; then
		ERROR=true
	fi
	VOLUME="$2"
	shift 2
	;;
	-r|--run)
	RUN=true
	shift
	;;
	-b|--build)
	BUILD=true
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
done

echo -e "\n\n"
echo '-----------------------------------------'
echo 'Installing docker & preparing the dev env'
echo '-----------------------------------------'
echo -e "\n"


#echo TAG = "${TAG}"
#echo NAME = "${NAME}"

if [[ "$VOLUME" != /* ]]; then
   VOLUME="$DIR/$VOLUME"
   echo VOLUME = "${VOLUME}"
fi

if [ ! -d "$VOLUME" ]; then
	echo "folder ${VOLUME} not found"
	echo "creating ${VOLUME}"
	mkdir "${VOLUME}"
fi

if [[ ${BUILD} == true ]]; then
	echo "building ${TAG} image"
	echo "TOOLCHAIN_CONFIG=$TOOLCHAINPREFIX --build-arg CROSSTOOL_VERION=$CROSSTOOLNG"
	docker build --build-arg TOOLCHAIN_CONFIG=$TOOLCHAINPREFIX --build-arg CROSSTOOL_VERION=$CROSSTOOLNG -t ${TAG} ..
fi

if [[ ${RUN} == true ]]; then
	if [ ! "$(docker ps -q -f name=${NAME})" ]; then
		if [ "$(docker ps -aq -f status=exited -f name=${NAME})" ]; then
        # cleanup
			echo 'docker with the same name found'
			echo 'deleting the existing image:'
        		docker rm ${NAME}
		fi
    # run your container
		if [ ! -d "$VOLUME" ]; then
			echo "folder ${VOLUME} not found"
			echo "creating ${VOLUME}"
			mkdir "${VOLUME}"
		fi
		if [ ! -d "$TOOLCHAIN" ]; then
			echo "folder ${TOOLCHAIN} not found"
			echo "creating ${TOOLCHAIN}"
			mkdir "${TOOLCHAIN}"
		fi
		echo "running ${NAME} container"
		docker run -it --privileged=true --name ${NAME} \
		-v "${VOLUME}":/home/build/workspace \
		-v "${TOOLCHAIN}":/home/build/x-tools \
		${TAG} \
		/bin/bash
 	else
		echo -e "image not found or already running"
	fi
fi
