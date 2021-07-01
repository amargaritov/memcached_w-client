#!/bin/bash -x

# install the client for memcached
sudo apt-get update 
echo "I want to install maven libevent-dev automake, please give me sudo"
sudo apt-get install maven make gcc g++ python -y 

pushd ycsb
cp ../ycsb_patch_4_arm64 ./
git checkout ce3eb9ce51c84ee9e236998cdd2cefaeb96798a8 
git apply ycsb_patch_4_arm64
mvn -pl site.ycsb:memcached-binding -am clean package
popd 

# install memcached itself
sudo apt-get install libevent-dev automake -y

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
SOURCE=$MY_DIR/memcached
INSTALL_D=$MY_DIR/install_location
mkdir -p $INSTALL_D

cd $SOURCE
./autogen.sh
./configure --prefix=$INSTALL_D
make -j
make install
sudo apt-get install linux-tools-common linux-tools-generic linux-tools-`uname -r` -y

