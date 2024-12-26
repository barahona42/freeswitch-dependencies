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

## install dnf packages
START_DIR=$(pwd)

section "installing dnf packages"

dnf update -y
dnf install -y $(cat ec2/dnf-requirements.txt | xargs)
updatedb || true

info "dnf packages installed"

section "preparing gcc-prereqs"
if [[ ! -f /var/gcc.tar.gz ]]; then
    info "downloading gcc tarball"
    wget -O /var/gcc.tar.gz https://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.gz
else
    info "gcc tarball already downloaded"
fi

info "extracting gcc tarball"
rm -rf /var/gcc && mkdir /var/gcc && tar -C /var/gcc --strip-components 1 -xzvf /var/gcc.tar.gz

## libgcc does not exist yet
section "applying patches to gcc"

bash scripts/patching/apply-patches.sh
info "patching completed"

section "downloading prerequisites"

cd /var/gcc && ./contrib/download_prerequisites

$(find /usr/share -maxdepth 1 -type d -name 'automake*')/config.guess > /var/build_host
info "build_host: $(< /var/build_host)"

section "starting gcc build"
export LD_PRELOAD=/usr/lib64/libstdc++.so.6
export LD_LIBRARY_PATH=/usr/lib64

info "created objdir"
rm -rf /var/objdir
mkdir /var/objdir
cd /var/objdir
info "configuring"
## TODO: try with build and target flags
../gcc/configure --disable-multilib --enable-languages=c,c++ --build=$(< /var/build_host) --host=$(< /var/build_host) 2>&1 | tee /var/log/gcc-conf
info "configuration completed at $(pwd)"
cd $START_DIR
bash scripts/notify-slack.sh "$(hostname) configure finished" "/var/log/gcc-conf"