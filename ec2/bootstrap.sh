#!/usr/bin/env bash

info(){
    printf "\033[35m%s\033[0m\n" "$1"
}

section(){
    printf "\033[35m-------------------------\033[0m\n\n"
    info "$1"
    printf "\033[35m-------------------------\033[0m\n\n"
}

## install dnf packages

dnf update -y
dnf install -y $(cat ec2/dnf-requirements.txt | xargs)