#!/bin/bash
messageSize="5000"
batchSize="10"
memQueueSize="1000000"
dataPath=`pwd`/tmp
chan="ch"


rm -rf ${dataPath}/*
mkdir -p tmp
sleep 5
echo "default channel type"
./benchv2.sh ${messageSize} ${batchSize} ${memQueueSize} ${dataPath} ${chan}

rm -rf ${dataPath}/*
sleep 5
echo "badger channel type"
chan="ch.badgerq"
# memQueueSize="0"
./benchv2.sh ${messageSize} ${batchSize} ${memQueueSize} ${dataPath} ${chan}

rm -rf ${dataPath}/*
sleep 5
echo "badger channel type, batch 100"
batchSize="100"
./benchv2.sh ${messageSize} ${batchSize} ${memQueueSize} ${dataPath} ${chan}

rm -rf ${dataPath}/*
