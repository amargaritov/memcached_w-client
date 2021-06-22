git clone git://git.qemu-project.org/qemu.git 
sudo apt-get update
sudo apt-get install ninja-build gcc g++ pkg-config make -y
sudo apt-get install build-essential zlib1g-dev pkg-config libglib2.0-dev binutils-dev libboost-all-dev autoconf libtool libssl-dev libpixman-1-dev libpython2-dev python3-pip python-capstone virtualenv -y
pushd qemu
mkdir build
pushd build
../configure --target-list=aarch64-softmmu --enable-kvm
make -j 40
popd
popd

