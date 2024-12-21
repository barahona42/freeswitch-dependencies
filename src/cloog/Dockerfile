FROM rocky810:rpmbuild-base
ADD https://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.gz /tmp/gcc.tar.gz
RUN mkdir /tmp/gcc && tar -C /tmp/gcc --strip-components 1 -xzvf /tmp/gcc.tar.gz
RUN dnf install -y gmp gmp-devel mpfr mpfr-devel libmpc libmpc-devel gcc-c++ wget
RUN cd /tmp/gcc && ./contrib/download_prerequisites
RUN cd /tmp/gcc/cloog && ./configure && make && make install && cloog --version
