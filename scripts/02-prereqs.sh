#!/usr/bin/env bash

source scripts/env.sh

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