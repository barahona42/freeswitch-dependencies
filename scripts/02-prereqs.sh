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

cd $WORKDIR/gcc && ./contrib/download_prerequisites

$(find /usr/share -maxdepth 1 -type d -name 'automake*')/config.guess > /var/build_host
info "build_host: $(< /var/build_host)"