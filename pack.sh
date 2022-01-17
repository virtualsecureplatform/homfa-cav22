#!/bin/bash

set -eux

rm -rf homfa homfa-experiment obom

GITHUB_DOMAIN=${GITHUB_DOMAIN:-"GitHub:"}
git clone -b cav22 ${GITHUB_DOMAIN}/virtualsecureplatform/homfa
cd homfa
git submodule update --init --recursive
rm -rf .git
cd ../
git clone -b cav22 ${GITHUB_DOMAIN}/virtualsecureplatform/homfa-experiment
rm -rf homfa-experiment/.git

mkdir obom
cp -r homfa obom/.
cp -r homfa-experiment obom/.
cp README.md obom/.

tar -zcvf obom.tar.gz obom
