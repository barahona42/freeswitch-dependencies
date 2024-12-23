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
if [[ ! -f /tmp/gcc.tar.gz ]]; then
    info "downloading gcc tarball"
    wget -O /tmp/gcc.tar.gz https://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.gz
fi
info "extracting gcc"
rm -rf /tmp/gcc && mkdir /tmp/gcc && tar -C /tmp/gcc --strip-components 1 -xzvf /tmp/gcc.tar.gz

info "downloading prerequisites"

cd /tmp/gcc && ./contrib/download_prerequisites

$(find /usr/share -maxdepth 1 -type d -name 'automake*')/config.guess > /var/build_host
info "build_host: $(< /var/build_host)"

info "building prerequisites"
dirs=(gmp cloog isl mpfr mpc)
for d in ${dirs[@]}; do
    info "prereq: /tmp/gcc/$d"
    cd /tmp/gcc/$d
    ./configure --build=$(</var/build_host)
    make
    make install
    info "$d: done"
done

section "applying patches to gcc"
patch_file=$(realpath ./src/gcc/patches/linux-unwind.patch)
cd /tmp/gcc/libgcc/config/i386 && patch < $patch_file
cd -

section "starting gcc build"
export LD_PRELOAD=/usr/lib64/libstdc++.so.6
# ./configure --disable-multilib --enable-languages=c,c++ --build=$(< /var/build_host)