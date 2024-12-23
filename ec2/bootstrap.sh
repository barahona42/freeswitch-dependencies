#!/usr/bin/env bash

info(){
    printf "\033[35m%s\033[0m\n" "$1"
}

section(){
    printf "\033[35m------------------------------\033[0m\n\n"
    info "$1"
    printf "\033[35m------------------------------\033[0m\n\n"
}

## install dnf packages

section "installing dnf packages"

dnf update -y
dnf install -y $(cat ec2/dnf-requirements.txt | xargs)

section "preparing gcc-prereqs"
wget -O /tmp/gcc.tar.gz https://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.gz
mkdir /tmp/gcc && tar -C /tmp/gcc --strip-components 1 -xzvf /tmp/gcc.tar.gz
cd /tmp/gcc && ./contrib/download_prerequisites
$(find /usr/share -maxdepth 1 -type d -name 'automake*')/config.guess > /var/build_host

info "build_host: $(< /var/build_host)"

dirs=(gmp cloog isl mpfr mpc)
for d in ${dirs[@]}; do
    info "building and installing /tmp/gcc/$d"
    cd /tmp/gcc/$d
    ./configure --build=$(</var/build_host)
    make
    make install
    info "done"
done