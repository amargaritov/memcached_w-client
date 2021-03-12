# memcached_w-client

This repository contains a script for 
- building Memcached 
- running it with a YCSB client

## Installation and use 

```bash 
git clone --recurse-submodules https://github.com/amargaritov/memcached_w-client.git
cd memcached_w-client
```

To build Memcached and setup the YCSB client run
```bash
./build_all_tools.sh 
```

To run a Memcached study use 
```bash 
./run_study.sh <DATASET_SIZE_IN_GB> <NUM_MEMCACHED_THREADS>
```

This script will 

- start a Memcached server
- load a dataset to Memcached (warm up)
- model client requests (total number of requests and read/write ration can be set in client_conf_default)

Note that number of records (which defines the Memcached dataset size) is set through a parameter of ./run_study.sh, don't change it in client_conf_default).
Note that NUM_MEMCACHED_THREADS should not be more than 8, I would say the good value is 4.
