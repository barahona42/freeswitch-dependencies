#!/usr/bin/env bash

for line in $(cat patches.txt); do
    mkdir -p src/gcc/patches/$(dirname $(realpath --relative-base ./tmp/gcc tmp/gcc/$line))
    diff -Naur tmp/gcc/$line.orig tmp/gcc/$line > src/gcc/patches/$line.patch
    echo "created src/gcc/patches/$line.patch"
done