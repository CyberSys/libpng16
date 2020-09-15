#!/bin/bash

build(){

    if [ $ARCH == "x86_64" ]; then
        echo "####### building for x86_64 #######"
        TARGET="--host=$ARCH-pc-nto-qnx7.1.0"
    elif [ $ARCH == "aarch64" ]; then
        echo "####### building for aarch64 #######"
        TARGET="--host=$ARCH-unknown-nto-qnx7.1.0"
    elif [ $ARCH == "arm" ]; then
        echo "####### building for arm #######"
        TARGET="--host=$ARCH-unknown-nto-qnx7.1.0eabi"
    elif [ $ARCH == "x86" ]; then
        echo "####### building for x86 #######"
        TARGET="--host=i586-pc-nto-qnx7.1.0"
    else
        echo "######### invalid $ARCH ##########"
        exit 1
    fi

OPT="$TARGET \
	--prefix=$PWD/nto/$CPUVARDIR/o \
	--includedir=$QNX_STAGE/usr/include \
	--libdir=$QNX_STAGE/$CPUVARDIR/usr/lib \
	--bindir=$QNX_STAGE/$CPUVARDIR/usr/bin \
	--sbindir=$QNX_STAGE/$CPUVARDIR/usr/sbin \
	--oldincludedir=$QNX_STAGE/usr/include \
	--sysconfdir=$QNX_STAGE/$CPUVARDIR/usr/etc \
	--datarootdir=$QNX_STAGE/$CPUVARDIR/usr/share"

echo "---------------------------------------------------------------"
echo "---------------------------------------------------------------"
echo $OPT
echo "---------------------------------------------------------------"
echo "---------------------------------------------------------------"

./configure $OPT

make
make install

}

rm -rfv nto

mkdir -p nto/x86_64/o
mkdir -p nto/aarch64le/o
mkdir -p nto/armle-v7/o

make clean
ARCH=x86_64
CPUVARDIR=$ARCH
build

make clean
ARCH=aarch64
CPUVARDIR=aarch64le
build

make clean
ARCH=arm
CPUVARDIR=armle-v7
build
