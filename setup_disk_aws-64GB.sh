   sudo parted /dev/nvme1n1 mklabel gpt
   sudo parted /dev/nvme1n1 mkpart primary ext4 16G 64G
   sudo mkfs -t ext4 /dev/nvme1n1
   sudo mkdir /disk
   sudo mount -t ext4 /dev/nvme1n1 /disk 
   sudo chmod 777 /disk
   cd /disk
   git clone --recurse-submodules https://github.com/amargaritov/memcached_w-client.git 
