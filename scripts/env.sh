#!/usr/bin/env bash

set -eu

info(){
    printf "\033[36m%s\033[0m\n" "$1"
}

BASE_IMAGE_TAG='rocky810/rpmbuild'


dir_to_tag(){
    echo "$BASE_IMAGE_TAG/$1"
}