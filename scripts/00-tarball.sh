#!/usr/bin/env bash

source scripts/env.sh

TARGET_VERSION="$1"

if ! test -d gcc-$TARGET_VERSION; then
    echo  "invalid target version"
fi

START_DIR=$(pwd)
WORKDIR=gcc-$TARGET_VERSION

source $WORKDIR/.build-env

if command -v dnf; then
    ## install dnf packages
    section "installing dnf packages"
    dnf update -y
    dnf install -y $(cat $WORKDIR/dnf-requirements.txt | xargs)
    updatedb || true
    info "dnf packages installed"
else
    info "skipping dnf packages because dnf command does not exist"
fi

## download gcc prerequisites
section "preparing gcc-prereqs"
if [[ ! -f $WORKDIR/gcc.tar.gz ]]; then
    wget -O $WORKDIR/gcc.tar.gz $GCC_TARBALL
else
    info "gcc tarball already downloaded"
fi

info "extracting gcc tarball"
rm -rf $WORKDIR/gcc && mkdir $WORKDIR/gcc && tar -C $WORKDIR/gcc --strip-components 1 -xzvf $WORKDIR/gcc.tar.gz

# ## libgcc does not exist yet
# section "applying patches to gcc"

# bash scripts/patching/apply-patches.sh
# info "patching completed"

# section "downloading prerequisites"

# cd /var/gcc && ./contrib/download_prerequisites

# $(find /usr/share -maxdepth 1 -type d -name 'automake*')/config.guess > /var/build_host
# info "build_host: $(< /var/build_host)"

# section "starting gcc build"
# export LD_PRELOAD=/usr/lib64/libstdc++.so.6
# export LD_LIBRARY_PATH=/usr/lib64

# info "created objdir"
# rm -rf /var/objdir
# mkdir /var/objdir
# cd /var/objdir
# info "configuring"
# ## TODO: try with build and target flags
# ../gcc/configure --disable-multilib \
#     --enable-languages=c,c++ \
#     --build=$(< /var/build_host) \
#     --host=$(< /var/build_host) 2>&1 | tee /var/log/gcc-conf
# info "configuration completed at $(pwd)"
# cd $START_DIR
# bash scripts/notify-slack.sh "$(hostname) configure finished" "/var/log/gcc-conf"