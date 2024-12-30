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
bash scripts/00-tarball.sh $TARGET_VERSION
bash scripts/01-patch.sh $TARGET_VERSION
bash scripts/02-prereqs.sh $TARGET_VERSION
bash scripts/03-configure.sh $TARGET_VERSION
bash scripts/04-make.sh $TARGET_VERSION
cd $START_DIR