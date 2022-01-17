# HomFA
This is the implementation of HomFA(Homomorphic Final Answer).
This package is expected to run on an Ubuntu 20.04 environment.

# Contents
This package contains below contents.

- homfa (implementation of homfa)
- homfa-experiment (scripts for Scalability Experiments and Blood Glucose Monitoring)

# Install dependencies
## homfa deps
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

## homfa-experiment deps
```
$ sudo apt install ruby-full rubygems libsqlite3-dev
$ sudo gem isntall byebug sqlite3
```

# Build
## Build homfa
```
$ cd homfa
$ mkdir build
$ cd build
$ cmake -DCMAKE_BUILD_TYPE=Release -DHOMFA_BUILD_BENCHMARK=On -DCMAKE_C_COMPILER=clang-10 -DCMAKE_CXX_COMPILER=clang++-10 ..
$ make -j$(nproc)
```

# Run tests and benchmarks
## homfa
```
$ cd homfa
$ ./test_homfa.sh (run test homfa)
$ ./bench.sh (run benchmark homfa)
```

## homfa-experiment
### Scalability Experiments
```
$ cd homfa-experiment/artificial-dfa
$ BUILD_BIN=../../homfa/build/bin ./bench.sh (run benchmark Scalability Experiments)
```

### Boold Glucose Monitoring
```
$ cd homfa-experiment/ap9
$ BUILD_BIN=../../homfa/build/bin ./test.sh (run test Boold Glucose Monitoring)
$ BUILD_BIN=../../homfa/build/bin ./bench.sh (run benchmark Boold Glucose Monitoring)
```
