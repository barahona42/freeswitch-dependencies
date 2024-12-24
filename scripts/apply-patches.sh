#!/usr/bin/env bash

for file in $(find src/gcc/patches -type f -name '*.patch'); do
    echo "${file%".patch"}"
done