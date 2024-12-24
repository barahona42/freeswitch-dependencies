#!/usr/bin/env bash

for file in $(find src/gcc/patches -type f -name '*.patch'); do
    source="$(realpath $file)"
    target="/tmp/gcc/$(realpath --relative-to src/gcc/patches "${file%.patch}")"
    echo -e "applying\n\t$source --> $target"
    cd "$(dirname $target)"
    patch < "$source"
    cd -
done