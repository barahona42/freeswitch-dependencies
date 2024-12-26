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

START_DIR=$(pwd)

cd /var/objdir
make -n -j 2 | tee /var/log/gcc-make

cd $START_DIR

bash scripts/notify-slack.sh "$(hostname) make finished" "/var/log/gcc-make"