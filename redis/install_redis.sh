
#!/bin/bash -x

# install the client for memcached
sudo apt-get update 
echo "I want to install maven libevent-dev automake, please give me sudo"
sudo apt-get install maven make gcc g++ python -y 

pushd ycsb
cp ../ycsb_patch_4_arm64 ./
git checkout ce3eb9ce51c84ee9e236998cdd2cefaeb96798a8 
git apply ycsb_patch_4_arm64
mvn -pl site.ycsb:redis-binding -am clean package
popd 

sudo apt-get install redis -y





# if want build from sources (not tested) 
#sudo add-apt-repository ppa:openjdk-r/ppa

#sudo apt-get update
#sudo apt-get install openjdk-8-jre -y
#
#sudo apt-get install libjemalloc-dev -y
#sudo apt-get install openjdk-8-jre openjdk-8-jdk -y
#
#sudo update-alternatives --config java
#
sudo apt-get install linux-tools-common linux-tools-generic linux-tools-`uname -r` -y

sudo service redis stop

sleep 60
ps aux | grep redis- | awk '{print $2}' | sudo kill -9 

sudo apt-get install python3-pip -y
sudo pip install psrecord 

