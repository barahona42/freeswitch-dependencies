#!/usr/bin/env bash

docker build -t freeswitch-dependencies/generate-patches -f - . <<EOM
FROM alpine AS base
RUN apk add bash diffutils patch wget ncurses tar

FROM base AS gcc-source
WORKDIR /var
ADD https://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.gz /var/gcc.tar.gz
RUN mkdir /var/gcc && tar -C /var/gcc --strip-components 1 -xzvf /var/gcc.tar.gz
ADD ./scripts/patching/apply-patches.sh /apply-patches.sh
EOM

docker run --rm -t -i -v ./gcc-patches:/var/gcc-patches freeswitch-dependencies/generate-patches bash /apply-patches.sh