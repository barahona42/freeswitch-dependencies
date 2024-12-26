#/bin/bash

set -u

info(){
    printf "\033[35m%s\033[0m\n" "$1"
}

section(){
    printf "\033[35m------------------------------\033[0m\n\n"
    info "$1"
    printf "\033[35m------------------------------\033[0m\n\n"
}

START_DIR="$(pwd)"

cd /var/objdir

export LD_PRELOAD='/usr/lib64/libstdc++.so.6'
export LD_LIBRARY_PATH='/usr/lib64'

make 2>&1 | tee /var/log/gcc-make

cd $START_DIR

bash scripts/notify-slack.sh "$(hostname) make finished" "/var/log/gcc-make"