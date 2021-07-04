sed -i "s/define EVBUFFER_MAX_READ_DEFAULT	4096/define EVBUFFER_MAX_READ_DEFAULT	65536/g" libevent/buffer.c 
sed -i "s/return 4096;/return 65536;/g" memcached/restart.c
