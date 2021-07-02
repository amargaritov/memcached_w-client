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


## Memcached takes memory size parameter in megabytes 
## calculate the size in MB + add approx. 5% on top of the dataset size 
##./install_location/bin/memcached -u -t $THREADS -m $(( $MEMORY * 1100 * 2)) --disable-evictions --memory-limit=20480 --extended hashpower=20 --extended no_lru_crawler --extended no_lru_maintainer -n 1000 > $CUR_DIR/server.log 2>&1 & pid=$!
#redis-server redis.conf > $CUR_DIR/server.log 2>&1 & pid=$! 
#taskset -p -c $SERVER_CORES $pid
#echo "Started server $(date)"

ssh -i "mg6.metal-test1.pem" ubuntu@$HOSTANME //disk/memcached_w-client/redis/start_server.sh & 
sleep 5

#warmup
echo "$(date) Warm up memcached..."
pushd ycsb
START_TIME=$SECONDS
./bin/ycsb load redis -s -P $CUR_DIR/client_conf_current -p "redis.hosts=$(hostname)" -p "redis.host=$HOSTNAME" -p "redis.port=6379" > $CUR_DIR/outputLoad.txt 2>&1 & warm_pid=$! 
#load redis -s -P $REPO_ROOT/workloads/ycsb-redis-binding-0.15.0/workloads/$WORKLOAD -p "redis.host=127.0.0.1" -p "redis.port=6379" -threads 8 > outputLoad.txt 2>&1
taskset -p -c $CLIENT_CORES $warm_pid
popd

wait $warm_pid
WARM_TIME=$(($SECONDS - $START_TIME))
echo $WARM_TIME > warm_time

# let THP do the job
sleep 20

echo "$(date) Starting client..."
pushd ycsb
START_TIME=$SECONDS
time ./bin/ycsb run  redis -s -P $CUR_DIR/client_conf_current -p "redis.hosts=$(hostname)" -p "redis.host=127.0.0.1" -p "redis.port=6379" > $CUR_DIR/outputRun.txt 2>&1 & client_pid=$!
taskset -p -c $CLIENT_CORES $client_pid
popd

wait $client_pid
CLIENT_TIME=$(($SECONDS - $START_TIME))
echo $CLIENT_TIME > client_time

#kill $pid
ssh -i "mg6.metal-test1.pem" ubuntu@$HOSTANME //disk/memcached_w-client/redis/kill_server.sh 

echo "Finished $(date)"
