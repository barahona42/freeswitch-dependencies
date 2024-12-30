#!/usr/bin/env bash

source scripts/env.sh

TARGET_VERSION="$1"

if ! test -d gcc-$TARGET_VERSION; then
    echo  "invalid target version"
fi

START_DIR=$(pwd)
WORKDIR=gcc-$TARGET_VERSION

source $WORKDIR/.build-env

section "applying patches to gcc"

# list files in patches
for file in $(find $WORKDIR/patches -iname '*.patch'); do
    target_file="$WORKDIR/gcc/$(realpath --relative-to $WORKDIR/patches "${file%.patch}")"
    if ! test -f "$target_file"; then
        info "could not find $target_file aborting."
        exit 1
    fi
    cp $target_file $target_file.orig
    patch --dry-run -B $WORKDIR --verbose -fi $file $target_file # TODO: no dry run, check 0, 1, or 2 status
    case $? in 
        0)
            info "all patching ok"
        ;;
        1)
            info "patching partial"
            exit 1
        ;;
        2)
            info "failed pathing"
            exit 1
        ;;
    esac
    diff -y --suppress-common-lines $target_file $target_file.orig
    info "========================="
done