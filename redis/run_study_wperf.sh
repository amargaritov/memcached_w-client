#!/bin/bash -x

if [ -z "$2" ]
  then
  echo "No argument supplied"
  exit 3
fi

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
	if [ ! -z "$pid" ]; then 
		echo -n "Killing server $pid..."
		kill -9 $pid
	fi
	if [ ! -z "$warm_pid" ]; then 
		echo -n "Killing warm $warm_pid..."
		kill -9 $warm_pid
	fi
	if [ ! -z "$client_pid" ]; then 
		echo -n "Killing client $client_pid..."
		kill -9 $client_pid
	fi
	if [ ! -z "$tpid" ]; then 
		echo -n "Killing time $tpid..."
		kill $tpid
	fi
	echo "** Trapped CTRL-C"
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

SERVER_CORES=0-3
CLIENT_CORES=4-63

CUR_DIR=$(pwd)

MEMORY="$1"       #provide memory size in GB
THREADS="$2"      #don't set more than 4, it doesn't scale beyond that!

echo "You provided:" 
echo "MEMORY (in GB)     = ${MEMORY}"
echo "THREADS            = ${THREADS}"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

# We've already done it when running build_tools.sh, right?
#pushd ycsb_memc
#mvn -pl site.ycsb:memcached-binding -am clean package
#popd

RECORD_COUNT=$(($MEMORY * 1024 * 1024))
cp ./client_conf_default ./client_conf_current
sed -i "s/replacemerecords/$RECORD_COUNT/g" ./client_conf_current


# Memcached takes memory size parameter in megabytes 
# calculate the size in MB + add approx. 5% on top of the dataset size 
redis-server redis.conf > $CUR_DIR/server.log 2>&1 & pid=$! 
taskset -p -c $SERVER_CORES $pid
echo "Started server $(date)"

sleep 5

#warmup
echo "$(date) Warm up memcached..."
pushd ycsb
START_TIME=$SECONDS
./bin/ycsb load redis -s -P $CUR_DIR/client_conf_current -p "redis.hosts=$(hostname)" -p "redis.host=127.0.0.1" -p "redis.port=6379" > $CUR_DIR/outputLoad.txt 2>&1 & warm_pid=$! 
taskset -p -c $CLIENT_CORES $warm_pid
popd

wait $warm_pid
WARM_TIME=$(($SECONDS - $START_TIME))
echo $WARM_TIME > warm_time

mkdir -p perf_data/$conf
pushd perf_data/$conf
sudo perf record -F 99 -a -g -p $pid &
popd

echo "$(date) Starting client..."
pushd ycsb
START_TIME=$SECONDS
time ./bin/ycsb run  redis -s -P $CUR_DIR/client_conf_current -p "redis.hosts=$(hostname)" -p "redis.host=127.0.0.1" -p "redis.port=6379" > $CUR_DIR/outputRun.txt 2>&1 & client_pid=$!
taskset -p -c $CLIENT_CORES $client_pid
popd

# let THP do the job
sleep 20

wait $client_pid
CLIENT_TIME=$(($SECONDS - $START_TIME))
echo $CLIENT_TIME > client_time

kill $pid
echo "Finished $(date)"

sleep 30 
CUR=$(pwd)/../
pushd perf_data/$conf
sudo perf script | $CUR/FlameGraph/stackcollapse-perf.pl > out.perf-folded
$CUR/FlameGraph/flamegraph.pl out.perf-folded > perf-kernel.svg
popd


