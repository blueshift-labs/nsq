#!/bin/bash
readonly messageSize="${1:-200}"
readonly batchSize="${2:-200}"
readonly memQueueSize="${3:-1000000}"
readonly dataPath="${4:-}"
readonly chan="${5:-ch}"
set -e
set -u

echo "# using --mem-queue-size=$memQueueSize --data-path=$dataPath --size=$messageSize --batch-size=$batchSize"
echo "# compiling/running nsqd"
pushd apps/nsqd >/dev/null
go build
rm -f *.dat
./nsqd --mem-queue-size=$memQueueSize --data-path=$dataPath >${dataPath}/nsq.log 2>&1 &
nsqd_pid=$!
popd >/dev/null

cleanup() {
    kill -9 $nsqd_pid
    rm -f nsqd/*.dat
}
trap cleanup INT TERM EXIT

sleep 0.3
echo "# creating topic/channel"
curl -X POST 'http://127.0.0.1:4151/topic/create?topic=sub_bench' 
curl -X POST 'http://127.0.0.1:4151/channel/create?topic=sub_bench&channel='${chan} 

echo "# compiling bench_reader/bench_writer"
pushd bench >/dev/null
for app in bench_reader bench_writer; do
    pushd $app >/dev/null
    go build
    popd >/dev/null
done
popd >/dev/null

echo -n "PUB: "
bench/bench_writer/bench_writer --size=$messageSize --batch-size=$batchSize 2>&1

curl -s -o cpu.pprof http://127.0.0.1:4151/debug/pprof/profile &
pprof_pid=$!

sleep 20 # need to wait for things to propogate to channel

echo -n "SUB: "
bench/bench_reader/bench_reader --size=$messageSize --channel=${chan} 2>&1

echo "waiting for pprof..."
wait $pprof_pid
