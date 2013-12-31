#!/bin/bash
 
# Create named pipes, one input and one output per process.
mkfifo in1 out1
mkfifo in2 out2
mkfifo in3 out3
mkfifo in4 out4
mkfifo in5 out5
mkfifo in6 out6
mkfifo in7 out7
 
# Starting the processes
./rou.tk --auto --ident=node1 < in1 > out1 &
./rou.tk --auto --ident=node2 < in2 > out2 &
./rou.tk --auto --ident=node3 < in3 > out3 &
./rou.tk --auto --ident=node4 < in4 > out4 &
./rou.tk --auto --ident=node5 < in5 > out5 &
./rou.tk --auto --ident=node6 < in6 > out6 &
./rou.tk --auto --ident=node7 < in7 > out7 &
 
# Waiting for the link creation (security delay)
sleep 1 
 
# Links creation: output -> input
# 1 -> 2 and 3
cat out1 | tee in2 in3 &
# 2 -> 1, 4 and 5
cat out2 | tee in1 in4 in5 &
# 3 -> 1 and 6
cat out3 | tee in1 in6 &
# 4 -> 2, 5 and 7
cat out4 | tee in2 in5 in7 &
# 5 -> 2 and 4
cat out5 | tee in2 in4 &
# 6 -> 3 and 7
cat out6 | tee in3 in7 &
# 7 -> 4 and 6
cat out7 | tee in4 in6 &
 
# Waiting 10 seconds before changing the topology
sleep 10
 
# Deleting link 5 <-> 2
# Deleting link 5 <-> 4
# Adding link 5 <-> 3
num=`ps aux | grep "cat out2" | grep -v grep | tr -s ' ' | cut -d' ' -f2`
kill -KILL $num
 
num=`ps aux | grep "cat out3" | grep -v grep | tr -s ' ' | cut -d' ' -f2`
kill -KILL $num 
 
num=`ps aux | grep "cat out4" | grep -v grep | tr -s ' ' | cut -d' ' -f2`
kill -KILL $num 
 
num=`ps aux | grep "cat out5" | grep -v grep | tr -s ' ' | cut -d' ' -f2`
kill -KILL $num 
 
# Creating new connections and recreating those that would not have been deleted.
cat out2 | tee in1 in4 &
cat out3 | tee in1 in5 in6 &
cat out4 | tee in2 in7 &
cat out5 | tee in3 &
 
# Waiting two seconds before pursuing
sleep 2
 
# Deleting link 6 <-> 7
num=`ps aux | grep "cat out6" | grep -v grep | tr -s ' ' | cut -d' ' -f2`
kill -KILL $num
 
num=`ps aux | grep "cat out7" | grep -v grep | tr -s ' ' | cut -d' ' -f2`
kill -KILL $num
 
# Re-creating links that would not have been deleted
cat out6 | tee in3 &
cat out7 | tee in4 &
 
# Waiting 20 secondes
sleep 20
 
# Killing all applications
killall rou.tk cat tee
 
# Deleting all named pipes
rm in* out*
