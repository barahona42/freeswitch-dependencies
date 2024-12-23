FROM rocky810/rpmbuild-base AS download
RUN dnf install -y automake bzip2 bzip2-devel bzip2-libs findutils
ADD https://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.gz /tmp/gcc.tar.gz
RUN mkdir /tmp/gcc && tar -C /tmp/gcc --strip-components 1 -xzvf /tmp/gcc.tar.gz
RUN cd /tmp/gcc && ./contrib/download_prerequisites
RUN $(find /usr/share -maxdepth 1 -type d -name 'automake*')/config.guess > /var/build_host

## gmp
FROM download AS build-gmp
RUN dnf install -y gcc make
WORKDIR /tmp/gcc/gmp
RUN ./configure --build=$(< /var/build_host)
RUN make
RUN make
RUN make install

## cloog
FROM build-gmp AS build-cloog
WORKDIR /tmp/gcc/cloog
RUN ./configure --build=$(< /var/build_host)
RUN make
RUN make install

## isl
FROM build-cloog AS build-isl
WORKDIR /tmp/gcc/isl
RUN ./configure --build=$(< /var/build_host)
RUN make
RUN make install

## mpfr
FROM build-isl AS build-mpfr
ENV LD_LIBRARY_PATH=/usr/local/include:/usr/local/lib
WORKDIR /tmp/gcc/mpfr
RUN ./configure --build=$(< /var/build_host)
RUN make
RUN make install

## mpc
FROM build-mpfr AS build-mpc
WORKDIR /tmp/gcc/mpc
RUN ./configure --build=$(< /var/build_host)
RUN make
RUN make install

## cleanup
FROM build-mpc
RUN rm -rf /tmp/gcc
WORKDIR /tmp