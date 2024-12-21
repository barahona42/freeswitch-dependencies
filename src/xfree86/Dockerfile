FROM freeswitch-dependencies AS base
RUN dnf update -y && dnf install -y glibc glibc-common glibc-devel glibc-headers glibc-utils

## installs tools needed during development.
## these should be skippable 
FROM base AS debugging-tools
RUN dnf install -y which mlocate wget
RUN updatedb

## downstream gettext fails make because glibc does not declare gets() so we'll try glibc < 2.15
### https://gcc.gnu.org/bugzilla/show_bug.cgi?id=51785
FROM debugging-tools AS deps-glibc

# gettext
FROM deps-glibc AS deps-gettext
## this fails help2man
# RUN dnf install -y gettext gettext-common-devel gettext-devel gettext-libs
## build gettext
ADD https://ftp.gnu.org/pub/gnu/gettext/gettext-0.18.tar.gz /tmp/
RUN mkdir /tmp/gettext && tar -C /tmp/gettext --strip-components 1 -xzvf /tmp/gettext-0.18.tar.gz
WORKDIR /tmp/gettext
RUN ./configure
## PAUSING here because glibc is failing make

# FROM deps-gettext AS deps-help2man
# ADD https://gnu.mirror.constant.com/help2man/help2man-1.36.4.tar.gz /tmp/
# RUN tar -C /tmp -xzvf /tmp/help2man-1.36.4.tar.gz

# ## for setting up flex2.5. it seems 2.6 breaks the ld -lfl lookup
# ## https://github.com/westes/flex/tree/flex-2.5.39
# ## NOTE: packages here may or may not be implicitly needed for xfree86
# FROM base AS flex-build
# ## TODO: probably should clone this
# RUN dnf install -y autoconf automake gettext bison bison-runtime 
# ADD https://gnu.mirror.constant.com/help2man/help2man-1.36.4.tar.gz /tmp/
# RUN tar -C /tmp -xzvf /tmp/help2man-1.36.4.tar.gz
# ADD https://github.com/westes/flex/releases/download/flex-2.5.39/flex-2.5.39.tar.gz /tmp/
# ## PENDING
# ## 


# # ## for setting up xfree86
# # FROM flex-build
# # # copy the source code
# # COPY ./source/xc /source/xc
# # # install lndir for shadow directory
# # RUN cd /source/xc/config/util && make -f Makefile.ini lndir && mv lndir /usr/bin/lndir
# # # create a shadow directory per docs/
# # RUN mkdir /source/build && cd /source/build && lndir ../xc
# # WORKDIR /source/build