FROM debian:jessie

ENV TOOLCHAIN_CONFIG=$TOOLCHAIN-PREFIX
ENV CROSSTOOL_VERION=$CROSSTOOL-NG

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils \
	&& DEBIAN_FRONTEND=noninteractive dpkg-reconfigure apt-utils \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
	build-essential gperf \
	bison flex texinfo wget \
	gawk libtool automake openssh-client \
	libncurses5-dev help2man rsync cmake skyeye\
	ca-certificates \
	&&  apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN DEBIAN_FRONTEND=noninteractive dpkg --add-architecture i386 \
	&& apt-get update \
	&& apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386

 RUN useradd -ms /bin/bash build
 USER build
 ENV HOME=/home/build
 WORKDIR ${HOME}

RUN mkdir -p ${HOME}/scripts
WORKDIR ${HOME}/scripts
ENV SCRIPTS ${HOME}/scripts
COPY scripts/build.sh ct-build
COPY scripts/syncRpi.sh ct-sync

RUN mkdir -p  ${HOME}/tools/
WORKDIR ${HOME}/tools/
ENV TOOLS=${HOME}/tools
 
ENV	CROSSTOOL_INSTALL=${TOOLS}/cross

RUN mkdir ct-build
ENV BUILD_DIR=ct-build

ENV TOOLCHAIN_PATH=${HOME}/x-tools/${TOOLCHAIN_CONFIG} \
    SYSROOT_PATH=${HOME}/x-tools/${TOOLCHAIN_CONFIG}/${TOOLCHAIN_CONFIG}/sysroot
ENV PATH=$TOOLCHAIN_PATH/bin:$SYSROOT_PATH:$SCRIPTS:$PATH

ENV arm-AR=${TOOLCHAIN_CONFIG}-ar \
	arm-AS=${TOOLCHAIN_CONFIG}-as \
	arm-LD=${TOOLCHAIN_CONFIG}-ld \
	arm-CC=${TOOLCHAIN_CONFIG}-gcc \
	arm-CXX=${TOOLCHAIN_CONFIG}-g++ \
	arm-GDB=${TOOLCHAIN_CONFIG}-gdb \
	arm-RANLIB=${TOOLCHAIN_CONFIG}-ranlib \
	ARCH=arm \
	CROSS_COMPILE=${TOOLCHAIN_CONFIG}-

EXPOSE 873

WORKDIR ${HOME}
RUN mkdir workspace
ENV WORKSPACE ${HOME}/workspace
WORKDIR ${HOME}/workspace

VOLUME ["${HOME}/workspace"]
VOLUME ["${HOME}/x-tools"]