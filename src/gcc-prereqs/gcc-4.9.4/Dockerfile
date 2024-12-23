FROM rocky810/rpmbuild/base AS download
RUN dnf install -y automake bzip2 bzip2-devel bzip2-libs findutils
ADD https://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.gz /tmp/gcc.tar.gz
# RUN mkdir /tmp/gcc && tar -C /tmp/gcc --strip-components 1 -xzvf /tmp/gcc.tar.gz
# RUN cd /tmp/gcc && ./contrib/download_prerequisites
# RUN $(find /usr/share -maxdepth 1 -type d -name 'automake*')/config.guess > /var/build_host