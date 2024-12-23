#!/usr/bin/env bash

## this script is intended to set up a fresh ec2 instance for build jobs

dnf update -y
dnf install -y $(cat dnf-install-list.txt | xargs)
