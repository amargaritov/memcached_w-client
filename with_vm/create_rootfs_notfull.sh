sudo apt-get install qemu qemu-user-static binfmt-support debootstrap -y 

wget -c http://cdimage.ubuntu.com/ubuntu-base/releases/16.04.6/release/ubuntu-base-16.04.6-base-arm64.tar.gz

fallocate -l 16384M rootfs.img
sudo mkfs.ext4 -F -L ROOTFS rootfs.img
mkdir mnt
sudo mount rootfs.img mnt
sudo tar -xzvf ubuntu-base-16.04.6-base-arm64.tar.gz -C mnt/
#sudo cp -a /usr/bin/qemu-aarch64-static mnt/usr/bin/

# run inside
#apt-get update; apt-get upgrade -y;  apt-get install ifupdown net-tools network-manager vim-tiny udev sudo ssh vim htop git make -y
