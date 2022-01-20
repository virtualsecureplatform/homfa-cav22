# Implementations of ReverseStream and BlockStream

This package includes the implementation of both ReverseStream and BlockStream,
and it also includes some scripts for experimental evaluations.
We expect these programs and the instructions here to run on Ubuntu 20.04 LTS.

# Contents

This package contains the following directories:

- homfa
  - The implementation of our algorithms.
- homfa-experiment
  - Scripts for experiments (for RQ1 and RQ2).

# How to Install Dependencies

## For homfa

```
$ sudo apt install build-essential clang-10 libtbb-dev cmake multitime
$ wget http://www.lrde.epita.fr/dload/spot/spot-2.9.7.tar.gz
$ tar -xvf spot-2.9.7.tar.gz
$ cd spot-2.9.7
$ ./configure --disable-python
$ make -j$(nproc)
$ sudo make install
$ cd ~
```

## For homfa-experiment

```
$ sudo apt install ruby-full rubygems libsqlite3-dev
$ sudo gem install byebug sqlite3
```

# How to Build

## For homfa

```
$ cd homfa
$ mkdir build
$ cd build
$ cmake -DCMAKE_BUILD_TYPE=Release -DHOMFA_BUILD_BENCHMARK=On -DCMAKE_C_COMPILER=clang-10 -DCMAKE_CXX_COMPILER=clang++-10 ..
$ make -j$(nproc)
```

# How to Run Experiments

## RQ1: Scalability Experiments

```
$ cd homfa-experiment/artificial-dfa
$ BUILD_BIN=../../homfa/build/bin ./bench.sh
```

## RQ2: Boold Glucose Monitoring

```
$ cd homfa-experiment/ap9
$ BUILD_BIN=../../homfa/build/bin ./bench.sh
```
