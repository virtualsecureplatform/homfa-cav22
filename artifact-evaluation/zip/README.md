# README

## Abstract

In this paper, we proposed two algorithms (Reverse and Block) to conduct online monitoring against a safety LTL specification via fully homomorphic encryption. We implemented these two algorithms in C++20 and experimentally answered two research questions (RQ1 and RQ2) we posed.

This artifact includes a Docker image including our C++20 programs and some scripts for the experiments to replicate our experimental results shown in the paper. It measures execution runtimes to generate monitored ciphertexts, execute our proposed algorithms using the inputs, and decrypt the result. It also has a functionality named _plaintext mode_, and one can check if the decrypted result is the same as the one executed in plaintext.

We note that the runtimes we presented in the paper were obtained on a workstation, and they will differ from the ones on a laptop. In this artifact, we also show the runtimes obtained on our laptop for reference.

System requirements to execute this artifact are as follows:
- CPU: 2 cores and 4 threads or more. It must support AVX2 and AES-NI, i.e., it must be Intel Core i 5000 series or newer, or AMD Ryzen 1000 series or newer.
- RAM: 4GiB or more
- Disk: 10GiB or more of free space
- Misc: Docker must be installed.

## Structure and Content of the Artifact

### In the Zip File

- `README`: This file.
- `LICENSE`: The license of this artifact (Apache License, Version 2.0).
- `homfa_cav22.tar.gz`: The Docker image.
- `Dockerfile`: The Dockerfile we used to obtain the docker image.

### In the Docker Image

- `/package/homfa-experiment/artificial-dfa/`: A directory for the experiment for RQ1.
    - `bench.sh`: A script to execute the experiment.
    - `check_result_correct.sh`: A script to check if the results are correct.
    - `spec/`: A directory for specification files (DFA definitions).
    - `in/`: A directory for input files (binary)
- `/package/homfa-experiment/ap9/`: A directory for the experiment for RQ2
    - `bench.sh`: A script to execute the experiment.
    - `check_result_correct.sh`: A script to check if the results are correct.
    - `*.spec` (Files suffixed with `.spec`): Specification files (DFA definitions).
    - `*.in` (Files suffixed with `.in`): Input files (binary)
- `/log/rq1`: A directory in which the produced logs for RQ1 exist.
- `/log/rq2`: A directory in which the produced logs for RQ2 exist.
- `/package/homfa_src`: A directory for source code.
- `/package/homfa`: A directory for built executable binary files.

## How to Start the Docker Image

1. Launch a terminal (or Command Prompt on Windows).
2. Execute `docker load -i homfa_cav22.tar.gz` to load the Docker image.
3. Execute `docker image ls` to check if the image is correctly loaded and `homfa cav22` is shown in the list.
4. Execute `docker run -it -v $PWD/log:/log homfa:cav22` to start a container of the image and enter it. The commands below are supposed to be executed in the container.
    - If you are using Command Prompt of Windows, please use `%cd%` instead of `$PWD`.
    - The option `-v $PWD/log:/log` above means that the directory `./log` of the host is mounted on `/log` of the guest (container). We will save all the log files in this directory in the following.

## How to Replicate the Results in the Paper

### Which Claims or Results of the Paper can be Replicated with the Artifact

- The results of RQ1 (Figure 4, Table 7, and Table 8)
- The results of RQ2 (Table 5 and Table 9) **except** for those for the algorithm Reverse with $\psi_1$ and $\psi_2$
    - We disabled the benchmark for Reverse with $\psi_1$ and $\psi_2$ because they need a lot of RAM (> 40GiB) and time (> 16,000 seconds), as shown in Table 9. If you want to enable them, please change the last arguments of lines 105 and 106 of `/package/homfa-experiment/ap9/bench.sh` from `0` to `1`.

Note that the results in the paper are obtained by executing this program on a workstation.  The results executed on a laptop will be different from those in the paper. The results obtained on our laptop is in the next section for reference.

We also note that memory usage of this artifact is reduced approximately by 2.5GiB compared to the one in the paper in all the experiments. This is because we fixed a bug which allocates an unnecessarily large memory block. We believe that this bugfix does not affect the overall performance of the artifact.

### Preparation

1. Execute `cd /package/homfa_src/` to change the current directory to the one for source code.
2. Execute `make prepare && make && make install` to build the code.
    - The built executable binary files are stored in `/package/homfa`.

### RQ1

1. Execute `cd /package/homfa-experiment/artificial-dfa/` to change the current directory to the one for RQ1.
2. Execute `./bench.sh /log/rq1` to conduct the experiment for RQ1.
    - After the experiment, you can see two kinds of log files in `/log/rq1`:
        - The files of pattern `(algorithm)_size-(#states)_size-(#inputs).log` (e.g., `bbs-150_size-0010_size-50000bit.log`) show the benchmark result (see below for the format of the files). Note that algorithm `bbs-150` means Block, `reversed` means Reverse, and `plain` means plaintext mode.
        - The files of pattern `(algorithm)_size-(#states)_size-(#inputs)_mem.log` (e.g., `bbs-150_size-0010_size-50000bit_mem.log`) show the output of GNU time.
3. Execute `./check_result_correct.sh /log/rq1` to check if the results are correct.
    - This script compares the output of Block and Reverse with the one of the plaintext mode.
    - If you want to check a log file (say `bbs-150_size-0010_size-50000bit.log`) manually, execute the following commands:
        - `grep "^result" /log/rq1/plain_size-0010_size-50000bit.log > _src`
            - The file `_src` consists of the outputs of plaintext mode.
        - `grep "^result" /log/rq1/bbs-150_size-0010_size-50000bit.log > _dst`
            - The file `_dst` consists of the outputs of the algorithm Block.
        - `diff _src _dst`
            - Nothing should be printed here because we expect `_src` and `_dst` are exactly the same.
4. Execute `ruby sqliteop.rb import res /log/rq1` to import then
    - Execute `ruby sqliteop.rb plot res /log` to plot the results, which will be saved as `/log/res-fixed-input.pdf` and `/log/res-fixed-state.pdf`. These figures correspond to Figure 4 in the paper.
    - Execute `ruby sqliteop.rb table res` to print table of the results as LaTeX code. These tables correspond to Table 7 and 8 in the paper.
    - If you want to remove the imported data for some reason, execute `rm artificial-dfa.sqlite3`.

### RQ2

1. Execute `cd /package/homfa-experiment/ap9/` to change the current directory to the one for RQ2.
2. Execute `./bench.sh /log/rq2` to conduct the experiment for RQ2.
    - After the experiment, you can see two kinds of log files in `/log/rq2`:
        1.  The files of pattern `(algorithm)_(spec)_(input).log` (e.g., `bbs_damon-001.spec_adult-001-7days-bg.in_9.log`) show the benchmark result (see below for the format of the files). Note that the algorithm `bbs` means Block, `reversed` means Reverse, and `plain` means plaintext mode. Also, the spec `damon-X` means $\phi_{X}$ and `towards-X` means $\psi_{X}$.
        2.  The files of pattern `(algorithm)_(spec)_(input)_mem.log` (e.g., `bbs_damon-001.spec_adult-001-7days-bg.in_9_mem.log`) show the output of GNU time.
3. Execute `./check_result_correct.sh /log/rq2` to check if the results are correct.
    - This script compares the output of Block and Reverse with the one of the plaintext mode.
    - If you want to check a log file (say `bbs_damon-001.spec_adult-001-7days-bg.in_9.log`) manually, execute the following commands:
        - `grep "^result" /log/rq2/plain_damon-001.spec_adult-001-7days-bg.in_9.log > _src`
            - The file `_src` consists of the outputs of plaintext mode.
        - `grep "^result" /log/rq2/bbs_damon-001.spec_adult-001-7days-bg.in_9.log > _dst`
            - The file `_dst` consists of the outputs of the algorithm Block.
        - `diff _src _dst`
            - Nothing should be printed here because we expect `_src` and `_dst` are exactly the same.
4. Execute `ruby sqliteop.rb import res /log/rq2` then
    - Execute `ruby sqliteop.rb table res` to print a table of the results as LaTeX code. This table corresponds to Table 5.
    - Execute `ruby sqliteop.rb detailed-table res` to print a detailed table of the results as LaTeX code. This table corresponds to Table 9.
    - If you want to remove the imported data for some reason, execute `rm ap9.sqlite3`.

### Format of Benchmark Results

The benchmark program outputs information and execution time to the log files (`*.log`) spent for processing monitored ciphertexts. Each line has one entry, separated by commas; the first column indicates an entry type, and the following columns are its values.

Some useful types of entries are as follows:

- Type: `result`
    - Values: Output of the algorithm, i.e., 0 or 1.
- Type: `enc`, `run`, `dec`
    - Values: Runtime (in microseconds) of encryption, running the algorithms, and decryption, respectively.

## An Example of Benchmark Results on a Laptop

We obtained the execution time presented in the paper on a workstation, which will be different from the result obtained on a laptop. We show the results obtained on our laptop for reference.

### System Environment

- CPU: AMD Ryzen 7 PRO 5850U (1.9GHz; 8 cores and 16 threads)
- RAM: 32GiB
- OS: Ubuntu 20.04.4 LTS (WSL2 on Windows 11 Pro (version 21H2))

### Result of the Experiment for RQ1

It took about 40 minutes for `bench.sh` to finish. Here is the result of `ruby sqliteop.rb table res`:
```
+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|                                       Table 7: Experimental resutls of M_m when the number of the states (i.e., m) is fixed to 500.                                       |
+-----------+----------------------------+--------------------+-----------------------------+------------------------------------+---------------------+--------------------+
| Algorithm | # of Monitored Ciphertexts | Runtime (CMux) (s) | Runtime (Bootstrapping) (s) | Runtime (CircuitBootstrapping) (s) | Runtime (Total) (s) | Memory Usage (GiB) |
+-----------+----------------------------+--------------------+-----------------------------+------------------------------------+---------------------+--------------------+
| Reverse   | 10000                      |              15.90 |                         --- |                                --- |               15.92 |               0.32 |
| Reverse   | 20000                      |              31.06 |                         --- |                                --- |               31.09 |               0.33 |
| Reverse   | 30000                      |              49.81 |                        1.23 |                                --- |               51.09 |               0.32 |
| Reverse   | 40000                      |              62.55 |                        1.18 |                                --- |               63.80 |               0.33 |
| Reverse   | 50000                      |              77.53 |                        1.14 |                                --- |               78.75 |               0.33 |
| Block     | 10000                      |              15.83 |                         --- |                              21.97 |               38.50 |               2.70 |
| Block     | 20000                      |              32.51 |                         --- |                              44.79 |               78.72 |               2.71 |
| Block     | 30000                      |              49.80 |                         --- |                              67.61 |              119.56 |               2.70 |
| Block     | 40000                      |              65.69 |                         --- |                              89.44 |              157.98 |               2.70 |
| Block     | 50000                      |              81.63 |                         --- |                             111.85 |              197.05 |               2.70 |
+-----------+----------------------------+--------------------+-----------------------------+------------------------------------+---------------------+--------------------+
+------------------------------------------------------------------------------------------------------------------------------------------------------------+
|                         Table 8: Experimental results of M_m when the number of monitored ciphertexts (i.e., n) is fixed to 50000.                         |
+-----------+-------------+--------------------+-----------------------------+------------------------------------+---------------------+--------------------+
| Algorithm | # of States | Runtime (CMux) (s) | Runtime (Bootstrapping) (s) | Runtime (CircuitBootstrapping) (s) | Runtime (Total) (s) | Memory Usage (GiB) |
+-----------+-------------+--------------------+-----------------------------+------------------------------------+---------------------+--------------------+
| Reverse   | 10          |               5.96 |                        0.03 |                                --- |                6.02 |               0.32 |
| Reverse   | 50          |              14.48 |                        0.14 |                                --- |               14.67 |               0.32 |
| Reverse   | 100         |              17.91 |                        0.24 |                                --- |               18.20 |               0.32 |
| Reverse   | 200         |              33.23 |                        0.46 |                                --- |               33.74 |               0.32 |
| Reverse   | 300         |              48.04 |                        0.70 |                                --- |               48.81 |               0.32 |
| Reverse   | 400         |              64.82 |                        0.92 |                                --- |               65.82 |               0.32 |
| Reverse   | 500         |              77.53 |                        1.14 |                                --- |               78.75 |               0.33 |
| Block     | 10          |               3.69 |                         --- |                              51.55 |               56.35 |               2.69 |
| Block     | 50          |               8.54 |                         --- |                              68.01 |               77.82 |               2.69 |
| Block     | 100         |              15.86 |                         --- |                              83.58 |              100.96 |               2.69 |
| Block     | 200         |              31.94 |                         --- |                              97.96 |              132.10 |               2.69 |
| Block     | 300         |              48.83 |                         --- |                             113.93 |              165.45 |               2.70 |
| Block     | 400         |              65.61 |                         --- |                             112.71 |              181.43 |               2.70 |
| Block     | 500         |              81.63 |                         --- |                             111.85 |              197.05 |               2.70 |
+-----------+-------------+--------------------+-----------------------------+------------------------------------+---------------------+--------------------+
```

### Result of the Experiment for RQ2

It took about 90 minutes for `bench.sh` to finish. Here is the result of `ruby sqliteop.rb table res`:

```
+-------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Table 5: Experimental results of blood glucose monitoring, where Q is the state space of the monitoring DFA and Q^R is the state space of the reversed DFA. |
+----------------------+----------------------+----------------------+---------------------------+--------------------+-------------+-------------------------+
| Formula              | |Q|                  | |Q^R|                | # of blood glucose values | Algorithm          | Runtime (s) | Mean Runtime (ms/value) |
+----------------------+----------------------+----------------------+---------------------------+--------------------+-------------+-------------------------+
| psi_1                |                10524 |              2712974 |                       721 | Reverse            |         --- |                     --- |
| psi_1                |                10524 |              2712974 |                       721 | Block              |       73.59 |                  102.06 |
| psi_2                |                11126 |              2885376 |                       721 | Reverse            |         --- |                     --- |
| psi_2                |                11126 |              2885376 |                       721 | Block              |       74.17 |                  102.87 |
| psi_4                |                 7026 |                  --- |                       721 | Reverse            |         --- |                     --- |
| psi_4                |                 7026 |                  --- |                       721 | Block              |       21.38 |                   29.66 |
+----------------------+----------------------+----------------------+---------------------------+--------------------+-------------+-------------------------+
| phi_1                |                   21 |                   20 |                     10081 | Reverse            |       12.72 |                    1.26 |
| phi_1                |                   21 |                   20 |                     10081 | Block              |      973.04 |                   96.52 |
| phi_4                |                  237 |                  237 |                     10081 | Reverse            |       67.97 |                    6.74 |
| phi_4                |                  237 |                  237 |                     10081 | Block              |     1818.20 |                  180.36 |
| phi_5                |                  390 |                  390 |                     10081 | Reverse            |      107.93 |                   10.71 |
| phi_5                |                  390 |                  390 |                     10081 | Block              |     1837.80 |                  182.30 |
+----------------------+----------------------+----------------------+---------------------------+--------------------+-------------+-------------------------+
```

Here is the result of `ruby sqliteop.rb detailed-table res`:

```
+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|    Table 9: Experimental results of blood glucose monitoring, where Q is the state space of the monitoring DFA and Q^R is the state space of the reversed DFA.     |
+---------+-------+---------+-------------+-----------+------------------+----------------+------------------+-------------------+------------------------+----------+
| Formula | |Q|   | |Q^R|   | # of values | Algorithm | Runtime(CMux)(s) | Runtime(B.)(s) | Runtime(C.B.)(s) | Runtime(Total)(s) | Mean Runtime(ms/value) | Mem(GiB) |
+---------+-------+---------+-------------+-----------+------------------+----------------+------------------+-------------------+------------------------+----------+
| psi_1   | 10524 | 2712974 |         721 | Reverse   |              --- |            --- |              --- |               --- |                    --- |      --- |
| psi_1   | 10524 | 2712974 |         721 | Block     |             0.39 |            --- |            57.80 |             73.59 |                 102.06 |     2.83 |
| psi_2   | 11126 | 2885376 |         721 | Reverse   |              --- |            --- |              --- |               --- |                    --- |      --- |
| psi_2   | 11126 | 2885376 |         721 | Block     |             0.39 |            --- |            58.49 |             74.17 |                 102.87 |     2.84 |
| psi_4   |  7026 |     --- |         721 | Reverse   |              --- |            --- |              --- |               --- |                    --- |      --- |
| psi_4   |  7026 |     --- |         721 | Block     |             0.19 |            --- |            11.28 |             21.38 |                  29.66 |     2.78 |
+---------+-------+---------+-------------+-----------+------------------+----------------+------------------+-------------------+------------------------+----------+
| phi_1   |    21 |      20 |       10081 | Reverse   |            12.60 |           0.05 |              --- |             12.72 |                   1.26 |     0.32 |
| phi_1   |    21 |      20 |       10081 | Block     |             5.33 |            --- |           950.97 |            973.04 |                  96.52 |     2.67 |
| phi_4   |   237 |     237 |       10081 | Reverse   |            67.67 |           0.19 |              --- |             67.97 |                   6.74 |     0.33 |
| phi_4   |   237 |     237 |       10081 | Block     |            13.26 |            --- |          1780.43 |           1818.20 |                 180.36 |     2.68 |
| phi_5   |   390 |     390 |       10081 | Reverse   |           107.46 |           0.33 |              --- |            107.93 |                  10.71 |     0.33 |
| phi_5   |   390 |     390 |       10081 | Block     |            17.17 |            --- |          1793.32 |           1837.80 |                 182.30 |     2.70 |
+---------+-------+---------+-------------+-----------+------------------+----------------+------------------+-------------------+------------------------+----------+
```


## Custom Datasets and Specifications

We explain how to execute this artifact with datasets and specifications other than RQ1 and RQ2.  Suppose we want to monitor a log against a specification $G(p_0 \lor p_1)$.  We encode $p_0 \land \neg p_1$ by a string `"10"`; $\neg p_0 \land p_1$ by `"01"`.  Then, a string `"10011001"` represents a sequence in which (1) $p_0 \land \neg p_1$ holds at time 0 and 2 and (2) $\neg p_0 \land p_1$ at time 1 and 3.  The following commands monitor this sequence against $G(p_0 \lor p_1)$. The result should be `1` at every time slot, i.e., the input sequence satisfies the specification.

1. Execute `cd /package/homfa/bin` to change the current directory to `/package/homfa/bin`.
2. Execute `./util ltl2spec 'G(p0 | p1)' 2 > _spec` to convert the formula to a DFA and save as `_spec`.
    - `G(p0 | p1)` indicates $G(p_0\lor p_1)$ by using the syntax of Spot (https://spot.lrde.epita.fr/tl.pdf).
    - `2` means the number of atomic propositions is two (`p0` and `p1`).
        - Note that atomic propositions must be formed as `pN`.
3. Execute `echo -n "10011001" | ruby /package/homfa-experiment/01tobin.rb 2 > _data` to format the data and save as `_data`.
4. Execute `./benchmark plain --spec _spec --in _data --out-freq 2 --ap 2 > _result_plain` to conduct the monitoring process using `_spec` and `_data` **in plaintext** (plaintext mode). Its output is saved as `_result_plain`, which we use for reference afterwards.
5. Execute `./benchmark reversed --spec _spec --in _data --bootstrapping-freq 30000 --out-freq 2 --ap 2 > _result_reverse` to conduct the **oblivious** monitoring process using `_spec` and `_data` with the algorithm **Reverse**. Its output is saved as `_result_reverse`.
6. Execute `./benchmark bbs --spec _spec --in _data --out-freq 2 --ap 2 --queue-size 2 > _result_block` to conduct the **oblivious** monitoring process using `_spec` and `_data` with the algorithm **Block**. Its output is saved as `_result_block`.
7. Check if the outputs are correct:
    - Execute `cat _result_plain`, `cat _result_reverse`, and `cat _result_block` to inspect the outputs. All of these files should have exact **four** lines of `result,1` which corresponds to the outputs of $\mbox{time}=0,1,2,3$.
8. Calculate runtimes:
    - Execute `/package/homfa-experiment/summarize-benchmark-result.sh _result_reverse` for Reverse.
    - Execute `/package/homfa-experiment/summarize-benchmark-result.sh _result_block` for Block.

## Source Code

The source code is located at `/package/homfa_src`.

The most relevant and interesting parts are:
- `/package/homfa_src/src/backstream_dfa_runner.cpp`, line 44--79 (`BackstreamDFARunner::eval`)
    - This is the function `BackstreamDFARunner::eval`, which implements the algorithm Reverse. Given a monitored ciphertext `input` as an argument, it executes one iteration of the main loop (lines 4--12 in Algorithm 3) using the input. More precisely, it applies `CMux` to all the states (note that `input_size_` in line 50 always evaluates to `false` here), and it evaluates `Bootstrapping` every `boot_interval_` consumption of the monitored ciphertexts.
- `/package/homfa_src/src/online_dfa.cpp`, line 97--224 (`OnlineDFARunner4::eval_queued_inputs`)
    - This is the function `OnlineDFARunner4::eval_queued_inputs`, which implements the algorithm Block. It conducts one iteration of the main loop (lines 3--19 in Algorithm 4) using a block of monitored ciphertexts (`queued_inputs_`). More precisely, it computes the states reachable from the initial state at the current block, applies `CMux` to all the states and the monitored ciphertexts of the block, and constructs a ciphertext representing the current state of the DFA for the next iteration.

## Relevant Log Files

The files are located at `/log/rq1` and `/log/rq2` for RQ1 and RQ2, respectively.
