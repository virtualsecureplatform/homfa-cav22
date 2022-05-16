#!/usr/bin/bash -xeu

# Thanks to: https://b.ueda.tech/?post=05953
# Thanks to: https://intoli.com/blog/exit-on-errors-in-bash-scripts/
set -o pipefail
on_debug(){
    last_command=$current_command
    current_command=$BASH_COMMAND
}
on_err(){
    echo "\"${last_command}\" command filed with exit code $?."
}
current_command=""
last_command=""
trap on_debug DEBUG
trap on_err ERR

print_error(){
  # Thanks to: https://stackoverflow.com/a/23550347
  echo
  echo -e "\e[1;31m[ERROR]\e[0m $@" >&2
  echo
}

failwith(){
  print_error "$@"
  exit 1
}

PACK_SH=$PWD/../pack.sh

rm -rf build
mkdir build
cd build
cp $PACK_SH .
GITHUB_DOMAIN=git@github.com: ./pack.sh
docker build -f ../Dockerfile -t homfa:cav22 .
rsync -av ../zip/ ../Dockerfile zip/
pandoc -f commonmark_x zip/README -o zip/README.pdf
docker save homfa:cav22 | gzip > zip/homfa_cav22.tar.gz
mv zip homfa_cav22
zip -r homfa_cav22.zip homfa_cav22
