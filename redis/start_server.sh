#!/bin/bash -x

CUR_DIR=$(pwd)
pushd /disk/memcached_w-client/redis
redis-server redis.conf > $CUR_DIR/server.log 2>&1 & pid=$! 
taskset -p -c $SERVER_CORES $pid
echo "Started server $(date)"
popd
