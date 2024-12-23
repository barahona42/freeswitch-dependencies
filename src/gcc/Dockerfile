## DEPENDS: gcc-prereqs
FROM rocky810/rpmbuild/gcc-prereqs
# ADD https://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.gz /tmp/gcc.tar.gz
RUN mkdir /tmp/gcc && tar -C /tmp/gcc --strip-components 1 -xzvf /tmp/gcc.tar.gz
# hotfix
ADD ./patches/ /tmp/gcc-patches
RUN cd /tmp/gcc/libgcc/config/i386 && patch < /tmp/gcc-patches/linux-unwind.patch
WORKDIR /tmp/gcc
RUN dnf install -y gcc-c++
# ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH
ENV LD_PRELOAD=/usr/lib64/libstdc++.so.6
RUN ./configure --disable-multilib --enable-languages=c,c++ --build=$(/usr/share/automake-1.16/config.guess)
