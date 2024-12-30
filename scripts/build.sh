#!/usr/bin/env bash

source scripts/env.sh

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

dnf clean all