FROM ubuntu:20.04
ARG SPOT_VERSION=2.9.7

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    cmake gcc g++ gcc-10 g++-10 ruby-full rubygems libsqlite3-dev libtbb-dev gnuplot-nox wget time \
    && rm -rf /var/lib/apt/lists/*

RUN gem install -N sqlite3 numo-gnuplot terminal-table

RUN wget https://www.lrde.epita.fr/dload/spot/spot-$SPOT_VERSION.tar.gz && \
    tar xf spot-$SPOT_VERSION.tar.gz && \
    cd spot-$SPOT_VERSION/ && \
    ./configure --disable-python && make -j$(nproc) && \
    make install && \
    cd .. && \
    rm -rf spot-$SPOT_VERSION.tar.gz spot-$SPOT_VERSION

COPY package /package

WORKDIR /package/homfa
RUN mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=gcc-10 -DCMAKE_CXX_COMPILER=g++-10 .. && \
    make -j$(nproc)

WORKDIR /package/homfa-experiment/
CMD ["bash"]
