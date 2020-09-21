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
    if [[ $? -ne 0 ]] ; then
        exit 1
    fi
    
    make install

}

echo "Building libpng16..."

if [ ! -d "${QNX_TARGET}" ]; then
    echo "QNX_TARGET is not set. Exiting..."
    exit 1
fi

if [ ! -d "${QNX_STAGE}" ]; then
    echo "QNX_STAGE is not set. Exiting..."
    exit 1
fi

# Download
wget https://sourceforge.net/projects/libpng/files/libpng16/1.6.37/libpng-1.6.37.tar.gz
tar -C . -xzvf libpng-1.6.37.tar.gz
rm -rf libpng-1.6.37.tar.gz
mv libpng-1.6.37/* .
rm -rf libpng-1.6.37

# Build
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
