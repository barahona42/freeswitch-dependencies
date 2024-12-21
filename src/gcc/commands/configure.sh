#!/usr/bin/env bash

cd /tmp/gcc
# disable multilib so we can skip the 32bit dependencies
./configure --disable-multilib