#!/bin/bash
N=3
NODES=""
for (( i=0; i<$N; i++ ))
do
    NODES+=" bully$i@`hostname`"
    erl -pa out/production/bully -name "bully$i" -s bully start ${NODES} -noshell &
    sleep 1
done
read
pkill beam.smp
