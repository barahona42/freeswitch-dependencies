#!/usr/bin/env bash

source scripts/env.sh

TARGET_VERSION="$1"

if ! test -d gcc-$TARGET_VERSION; then
    echo  "invalid target version"
fi

START_DIR=$(pwd)
WORKDIR=gcc-$TARGET_VERSION

source $WORKDIR/.build-env

rm -rf $WORKDIR/objdir && mkdir $WORKDIR/objdir
mkdir -p $WORKDIR/log

cd $WORKDIR/objdir
../gcc/configure --disable-multilib --enable-languages=c,c++ 2>&1 | tee $WORKDIR/log/configure.log