# freeswitch-dependencies

a repository for packaging various utilities used by freeswitch

## usage

the idea behind this repo is to set up a repeatable and containerized flow for building various "freeswitch" dependencies. at the top-level, the Dockerfile defines a base rockylinux image.

under src, a number of directories with corresponding Dockerfiles based on the base rockylinux image are defined. these are intended to encapsulate the build flow as much as possible so it's easier to maintain.

the build order thus far:
```
/Dockerfile
/src/gcc-prereqs/Dockerfile
/src/gcc/Dockerfile
```
a set of scripts are provided under `scripts` to make build/run operations on container images easier:
- `build-image [SRC_BASENAME]`
- `run-image [SRC_BASENAME]` 

## todo

- [ ] build gcc prereqs
- [ ] build gcc
- [ ] build glibc
- [ ] build xfree86

- [ ] base image for rpm builds
- [ ] modify existing build containers to generate rpm files
- [ ] self-host archives for build dependencies

## from gmp
```
Libraries have been installed in:
   /usr/local/lib

If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the `-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the `LD_RUN_PATH' environment variable
     during linking
   - use the `-Wl,--rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to `/etc/ld.so.conf'
```
## issues
- mpfr config.log showed that libgmp.so.3 did not exist
  - relevant files:
    - ./usr/local/include/gmp.h6
    - ./usr/local/lib/libgmp.so.3
    - failed command: `gcc -c -Wall -Wmissing-prototypes -Wpointer-arith -g -O2 conftest.c
`
  - confirmed both files exist in filesystem after gmp `make install`
  - the solution, to inform LD of the libraries' location
      ```dockerfile
      ENV LD_LIBRARY_PATH=/usr/local/include:/usr/local/lib
- gcc `make` failed due to missing `CXXABI_1.3.9`
  - confirmed `/usr/lib64/libstdc++.so.6` includes required version
  - the solution, to preload the file:
      ```dockerfile
      ENV LD_PRELOAD=/usr/lib64/libstdc++.so.6
- gcc `make` failed due to `sys/ustat.h: no such file or directory6`
  - looks like sys/ustat.h was removed on glibc 2.28. will need to downgrade.
  - review [holy-build-box](https://phusion.github.io/holy-build-box/)