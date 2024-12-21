# freeswitch-dependencies

a repository for packaging various utilities used by freeswitch

## todo

- [ ] create a base container image that will be used for all rpm builds
- [ ] create a per-package container
- [ ] i might be able to do `make` and copy the made files over to another stage to run `make install`
- [ ] set up an ftp server or something to host the tar.gz stuff

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

```bash
cat << EOF > $HOME/local/share/config.site
> CPPFLAGS=-I$HOME/local/include
> LDFLAGS=-L$HOME/local/lib
> LD_LIBRARY_PATH=/usr/local/lib
> LD_RUN_PATH=/usr/local/lib
> EOF
```

./usr/local/include/gmp.h
./usr/local/lib/libgmp.so.3


gcc -c -Wall -Wmissing-prototypes -Wpointer-arith -g -O2 conftest.c
