#!/usr/bin/env bash

set -eu

info(){
    printf "\033[35m%s\033[0m\n" "$1"
}

section(){
    printf "\033[35m------------------------------\033[0m\n\n"
    info "$1"
    printf "\033[35m------------------------------\033[0m\n\n"
}

BASE_IMAGE_TAG='rocky810/rpmbuild'


dir_to_tag(){
    echo "$BASE_IMAGE_TAG/$1"
}