# homfa-cav22

This repository contains files we used to generate [HomFA](https://github.com/virtualsecureplatform/homfa)'s artifacts submitted to CAV'22.
Please see the HomFA's page for the detail.

## Build and Run

```
$ cd artifact-evaluation
$ mkdir build && cd build
$ cp ../../pack.sh .
$ ./pack.sh
$ docker build -f ../Dockerfile -t homfa:cav22 .
$ docker run -it -v $PWD/log:/log homfa:cav22
```

See [the artifact's README](https://github.com/virtualsecureplatform/homfa-cav22/blob/master/artifact-evaluation/zip/README.md) for its usage.
