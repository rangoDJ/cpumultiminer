#!/bin/sh
algo=$1
poolUrl=$2
wallet=$3
coin=$4
cpuPriority=$5
useScheduler=$6 # true / false
startTime=$7 #e.g. 1530 or 1100 for time
stopTime=$8 #e.g. 1530 or 1100 for time
days=$9 #e.g. "Tuesday,Friday"
miner="/cpuminer/cpuminer"

#$miner -a x16r -o stratum+tcp://ravenminer.com:3336 -u RFG2SL3jtheTPg6c9GKUNzKmQQg6uNfegk -p c=RVN --cpu-priority=2
$miner -a $algo -o $poolUrl -u $wallet -p c=$coin --cpu-priority=$cpuPriority
