#!/usr/bin/env bash

set -u

info(){
    printf "\033[35m%s\033[0m\n" "$1"
}

section(){
    printf "\033[35m------------------------------\033[0m\n\n"
    info "$1"
    printf "\033[35m------------------------------\033[0m\n\n"
}

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