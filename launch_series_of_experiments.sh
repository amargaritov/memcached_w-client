mkdir -p studies/4KB/{THP,noTHP}

#./disable_thp_no_drop.sh
#conf=noTHP; for i in {1..1}; do ./run_study.sh 8 4; mv warm_time studies/4KB/$conf/warm_time_$i; mv client_time studies/4KB/$conf/client_time_$i; mv outputRun.txt ./studies/4KB/$conf/outputRun_$i; sleep 1; done

#./enable_thp_no_drop.sh
conf=THP; for i in {1..1}; do ./run_study.sh 8 4; mv warm_time studies/4KB/$conf/warm_time_$i; mv client_time studies/4KB/$conf/client_time_$i; mv outputRun.txt ./studies/4KB/$conf/outputRun_$i; sleep 20; done
