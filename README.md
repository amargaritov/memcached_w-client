# memcached_w-client

This repository contains a script for 
- building Memcached 
- running it with a YCSB client

To build Memcached run
```bash
build_all_tools.sh 
```

To run Memcached use 
```bash 
run_study.sh <DATASET_SIZE_IN_GB> <NUM_MEMCACHED_THREADS>

Note that NUM_MEMCACHED_THREADS should not be more than 8, I would say the good value is 4.
