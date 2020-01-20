#!/bin/bash
data=`pwd`/tmp
# echo "normal"
# ./bbench.sh 500000 10 1000000 ch

# sleep 5

# echo "badger"
# ./bbench.sh 500000 10 1000000 ch.badgerq

rm -rf ${data}/*
sleep 5
echo "normal low memory"
./benchv2.sh 500000 10 0 ${data} ch
# PUB: [bench_writer] 2020/01/17 15:36:35 duration: 10.202758778s - 277.612mb/s - 582.195ops/s - 1717.636us/op
# SUB: [bench_reader] 2020/01/17 15:36:45 duration: 10.045179562s - 281.967mb/s - 591.328ops/s - 1691.108us/op

rm -rf ${data}/*
sleep 5
echo "badger low memory"
./benchv2.sh 500000 10 0 ${data} ch.badgerq
# PUB: [bench_writer] 2020/01/17 15:37:21 duration: 10.106688933s - 280.251mb/s - 587.730ops/s - 1701.463us/op
# SUB: [bench_reader] 2020/01/17 15:37:32 duration: 10.319211776s - 274.480mb/s - 575.625ops/s - 1737.241us/op

rm -rf ${data}/*
sleep 5
echo "normal low memory small message"
./benchv2.sh 5000 10 0 ${data} ch


rm -rf ${data}/*
sleep 5
echo "badger low memory small message"
./benchv2.sh 5000 10 0 ${data} ch.badgerq