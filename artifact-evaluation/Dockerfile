FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    cmake gcc g++ gcc-10 g++-10 ruby-full rubygems libsqlite3-dev libtbb-dev gnuplot-nox wget time \
    && rm -rf /var/lib/apt/lists/*

RUN gem install -N byebug sqlite3 numo-gnuplot

RUN wget https://www.lrde.epita.fr/dload/spot/spot-2.9.7.tar.gz && \
    tar xf spot-2.9.7.tar.gz && \
    cd spot-2.9.7/ && \
    ./configure --disable-python && make -j$(nproc) && make install

COPY package /package

WORKDIR /package/homfa
RUN mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DHOMFA_BUILD_BENCHMARK=On -DCMAKE_C_COMPILER=gcc-10 -DCMAKE_CXX_COMPILER=g++-10 .. && \
    make -j$(nproc)

WORKDIR /package/homfa-experiment/
CMD ["bash"]
