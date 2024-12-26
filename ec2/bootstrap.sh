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

## install dnf packages

section "installing dnf packages"

dnf update -y
dnf install -y $(cat ec2/dnf-requirements.txt | xargs)

updatedb || true

section "preparing gcc-prereqs"
if [[ ! -f /var/gcc.tar.gz ]]; then
    info "downloading gcc tarball"
    wget -O /var/gcc.tar.gz https://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.gz
fi
info "extracting gcc"
rm -rf /var/gcc && mkdir /var/gcc && tar -C /var/gcc --strip-components 1 -xzvf /var/gcc.tar.gz

## libgcc does not exist yet
section "applying patches to gcc"

bash scripts/patching/apply-patches.sh

# for file in $(find src/gcc/patches -type f -name '*.patch'); do
#     source="$(realpath $file)"
#     target="/tmp/gcc/$(realpath --relative-to src/gcc/patches "${file%.patch}")"
#     test -f $target || echo "skipping patch due to missing target: '$target'" && continue
#     test -f $source || echo "skipping patch due to missing source: '$source'" && continue
#     test -d $(dirname $target) || echo "skipping patch due to missing target directory '$(dirname $target)'" && continue
#     # echo -e "applying\n\t$source --> $target"
#     # cd "$(dirname $target)"
#     # patch < "$source"
#     cd -
# done
exit 0
info "downloading prerequisites"

cd /tmp/gcc && ./contrib/download_prerequisites

$(find /usr/share -maxdepth 1 -type d -name 'automake*')/config.guess > /var/build_host
info "build_host: $(< /var/build_host)"

## we don't need to configure and install these prerequisites ourselves. gcc build will do  q
# dirs=(gmp cloog isl mpfr mpc)
# for d in ${dirs[@]}; do
#     info "prereq: /tmp/gcc/$d"
#     cd /tmp/gcc/$d
#     ./configure --build=$(</var/build_host)
#     make
#     make install
#     info "$d: done"
# done

# patch_file=$(realpath ./src/gcc/patches/linux-unwind.patch)
# cd /tmp/gcc/libgcc/config/i386 && patch < $patch_file
# cd -

section "starting gcc build"
export LD_PRELOAD=/usr/lib64/libstdc++.so.6
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64

info "created objdir"
rm -rf /tmp/objdir
mkdir /tmp/objdir
cd /tmp/objdir
info "configuring"
../gcc/configure --disable-multilib --enable-languages=c,c++ 

cd -
# bash scripts/notify-slack.sh "ec2 bootstrap completed"
## TODO: build without setting the build flag?
# ../gcc/configure --disable-multilib --enable-languages=c,c++ --build=$(< /var/build_host) --prefix=$HOME/gcc
# make -j 2