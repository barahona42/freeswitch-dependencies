for file in $(cat gcc-patches/target-files.txt); do
    # make a backup of the original
    test -f /var/gcc/$file || (echo "missing target file: /var/gcc/$file" && exit 1)
    cp -v /var/gcc/$file /var/gcc/$file.orig
    # find the patch file
    test -f gcc-patches/$file.patch || (echo "missing patch file: gcc-patches/$file" && exit 1)
    patch -fi gcc-patches/$file.patch /var/gcc/$file
    diff -y --suppress-common-lines --suppress-blank-empty /var/gcc/$file /var/gcc/$file.orig
done