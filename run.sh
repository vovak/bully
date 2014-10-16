#!/bin/bash
N=5
NODES=""
for (( i=0; i<$N; i++ ))
do
    NODES+=" bully$i@`hostname`"
done

for (( i=0; i<$N; i++ ))
do
    erl -pa out/production/bully -name "bully$i@`hostname`" -s bully start ${NODES} -noshell &
#    sleep 1
done
read
pkill beam.smp
