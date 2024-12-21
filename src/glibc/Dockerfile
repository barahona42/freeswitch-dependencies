FROM rocky810:rpmbuild-base
ADD https://ftp.gnu.org/gnu/glibc/glibc-2.14.tar.gz /tmp/glibc.tar.gz
RUN mkdir /tmp/glibc && tar -C /tmp/glibc --strip-components 1 -xzvf /tmp/glibc.tar.gz
