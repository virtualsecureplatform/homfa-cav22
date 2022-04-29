# Files of HomFA for Artifact Evaluation

##

```
sudo apt update
sudo apt install -y cmake gcc g++ gcc-10 g++-10 ruby-full rubygems libsqlite3-dev libtbb-dev gnuplot-nox
sudo gem install -N byebug sqlite3 numo-gnuplot

wget https://www.lrde.epita.fr/dload/spot/spot-2.9.7.tar.gz
tar xf spot-2.9.7.tar.gz

cd spot-2.9.7/
./configure --disable-python && make -j$(nproc) && sudo make install
cd ..

wget -O package.tar.gz https://figshare.com/ndownloader/files/33674795?private_link=8b915f68d0b291b2c70b
tar xf package.tar.gz

cd package/homfa
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DHOMFA_BUILD_BENCHMARK=On -DCMAKE_C_COMPILER=gcc-10 -DCMAKE_CXX_COMPILER=g++-10 ..
make -j$(nproc)
cd ../../..

```

##

```
cd package/homfa-experiment/artificial-dfa
./bench.sh log
./check_result_correct.sh log
ruby sqliteop.rb import rq1 log
ruby sqliteop.rb plot rq1
ruby sqliteop.rb tabular rq1
```

##

```
cd package/homfa-experiment/ap9
BUILD_BIN=../../homfa/build/bin ./bench.sh
./check_result_correct.sh XXXXXXXXXXXXXX
ruby sqliteop.rb import rq2 XXXXXXXXXXXXXX
ruby sqliteop.rb tabular rq2
ruby sqliteop.rb detailed-tabular rq2
```
