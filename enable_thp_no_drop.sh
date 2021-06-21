#!/bin/bash 

CUR_DIR=$(pwd)

display_usage() { 
echo -e "\nUsage: [install_path]\n" 
} 

check_if_succeeded() {
	if [ $? -eq 0 ]; then
	    echo OK
	else
	    echo FAIL
	    exit 1
	fi
}


prepare_system() {
	echo "Enable THP..."

  sudo sh -c "echo 'always' > /sys/kernel/mm/transparent_hugepage/enabled"
  sudo sh -c "echo 'always' > /sys/kernel/mm/transparent_hugepage/defrag"
  sudo sh -c "echo 0 > /sys/kernel/mm/transparent_hugepage/khugepaged/scan_sleep_millisecs"

#	echo "Drop OS caches..."
#	sudo sync; 
#  sudo sh -c "echo '3' > /proc/sys/vm/drop_caches"
}

prepare_system
