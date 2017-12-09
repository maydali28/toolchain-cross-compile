#! /bin/bash
#setup & installation

HELP_MSG="\nUsage: ./build.sh COMMAND \
	\n\nBuild Manager \
	\n\nCommands \
	\n\n \
	-t, --toolchain= Install and build cross compiler toolchain\
	\n \
 	-h, --help= Print usage \
	\n"

B_TOOLCHAIN=flase
ERROR=false

key="$1"

case $key in
	-t|--toolchain)
	if [[ $2 == *"-"* ]]; then
		ERROR=true
	fi
    B_TOOLCHAIN=true
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
    echo "See './build.sh --help' or './build.sh -h'."
    exit 0
fi

if [[ ${B_TOOLCHAIN} == true ]]; then
    echo "Downloading ${CROSSTOOL_VERION}"
    cd $TOOLS \
    && wget http://crosstool-ng.org/download/crosstool-ng/${CROSSTOOL_VERION}.tar.bz2 2>&1 \
 	&& tar xjf ${CROSSTOOL_VERION}.tar.bz2 \
 	&& rm ${CROSSTOOL_VERION}.tar.bz2 \
 	&& cd ${CROSSTOOL_VERION} \
	&& ./configure -prefix=${CROSSTOOL_INSTALL} \
 	&& make && make install \
	&& ./ct-ng ${TOOLCHAIN_CONFIG} \
	&& cp .config ${TOOLS}/${BUILD_DIR}/.config \
 	&& cd ${TOOLS} \
    echo "building toolchain"

    cd ${TOOLS}/${BUILD_DIR} \
    &&	${CROSSTOOL_INSTALL}/bin/ct-ng build
fi
