#!/bin/bash

set -eux

rm -rf homfa homfa-experiment package

GITHUB_DOMAIN=${GITHUB_DOMAIN:-"GitHub:"}
git clone -b cav22 ${GITHUB_DOMAIN}/virtualsecureplatform/homfa
cd homfa
git submodule update --init --recursive
cd ../
git clone -b cav22 ${GITHUB_DOMAIN}/virtualsecureplatform/homfa-experiment
find homfa homfa-experiment -name ".git*" | xargs rm -rf

mkdir package
cp -r homfa package/.
cp -r homfa-experiment package/.
cp README.md package/.

tar -zcvf package.tar.gz package
