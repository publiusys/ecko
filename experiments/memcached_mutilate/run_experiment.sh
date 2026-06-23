#!/usr/bin/env bash
# Author(s): Yara Awad
#            Seth Moore (slmoore@hamilton.edu)
# Brief: 

port=11211
server=10.10.1.1
agent1=10.10.1.2
agent2=10.10.1.3

run_experiment() {
        echo "START MEMCACHED 16 THREADS"
        ssh $server "taskset -c 0-15 memcached -p $port -u nobody -t 16 -m 32G -c 8192 -b 8192 -l $server -B binary > mcd_11211.log 2>&1 < /dev/null &"

        echo "START LOAD GENERATION AGENTS"
        ssh $agent1 "mutilate --agentmode --threads=16 > agent.log 2>&1 < /dev/null &"
        ssh $agent2 "mutilate --agentmode --threads=16 > agent.log 2>&1 < /dev/null &"

        echo "LOAD MEMCACHED DATABASE"
        taskset -c 0 mutilate -vv --binary -s $server:$port --loadonly -K fb_key -V fb_value

        sleep 1

        update=$1
        qps=$2

        echo "START RUN UPDATE $update QPS $qps"
        mkdir -p exp/$update\_$qps/

        # start load generation for 1 mcd process
        taskset -c 0 mutilate --binary -s $server:$port --noload --agent={$agent1,$agent2} --threads=1 --keysize=fb_key --valuesize=fb_value --iadist=fb_ia --update=0.25 --depth=128 --measure_connections=32 --qps=$qps --time=30 >> exp/$update\_$qps/leader.log

        scp -r $agent1:~/agent.log exp/$update\_$qps/agent1.log
        scp -r $agent2:~/agent.log exp/$update\_$qps/agent2.log
        ssh $agent1 "sudo killall mutilate"
        ssh $agent2 "sudo killall mutilate"
        ssh $server "sudo killall memcached"
}

echo "CREATE TEMP EXP DIR"
mkdir -p exp/
rm -rf exp/*

for i in 20000 40000 60000 80000 100000 120000 140000 160000 180000 200000 220000 240000 260000 280000 300000 320000 340000 360000 380000 400000; do
        run_experiment 0.25 $i
        sleep 1
done
