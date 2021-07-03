mkdir -p studies/4KB/{THP,noTHP}

./disable_thp_no_drop.sh
conf=noTHP; for i in {1..3}; do ./run_study.sh 8 1; mv resmem.log studies/4KB/$conf/resmem.log_$i; mv warm_time studies/4KB/$conf/warm_time_$i; mv client_time studies/4KB/$conf/client_time_$i; mv outputRun.txt ./studies/4KB/$conf/outputRun_$i; sleep 10; done

./enable_thp_no_drop.sh
conf=THP; for i in {1..3}; do ./run_study.sh 8 1; mv resmem.log studies/4KB/$conf/resmem.log_$i; mv warm_time studies/4KB/$conf/warm_time_$i; mv client_time studies/4KB/$conf/client_time_$i; mv outputRun.txt ./studies/4KB/$conf/outputRun_$i; sleep 10; done
