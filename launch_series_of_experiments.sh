for i in {1..10}; do ./run_study.sh 8 4; mv warm_time studies/4KB/THP/warm_time_$i; mv client_time studies/4KB/THP/client_time_$i; sleep 20; done
