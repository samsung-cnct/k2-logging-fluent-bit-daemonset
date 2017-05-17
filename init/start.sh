#! /bin/bash

# start fluent-bit and get PID to monitor resource consumption
/fluent-bit/bin/fluent-bit -v -e /fluent-bit-kafka-output-plugin/out_kafka.so -c /fluent-bit/etc/fluent-bit.conf &

# get process id of last ran command (fluentd)
PID=$!
echo "my PID is $PID"

# start monitoring fluent-bit
# warning - this will run forever
# set a time cap or manually delete
# after tests have ran.
while [ 1 ]; do

CPU=$(ps -p $PID -o %cpu=)
MEM=$(ps -p $PID -o rss=)
echo "[metrics]: $CPU $MEM"

sleep 2
done

# wait for fluent-bit to exit
wait $PID