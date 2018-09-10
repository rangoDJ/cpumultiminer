#!/bin/bash
algoMode=$1
poolUrl=$2
poolUser=$3
poolPW=$4
maxCpu=$5
useScheduler=$6 # true / false
startTime=$7 #e.g. 1530 or 1100 for time
stopTime=$8 #e.g. 1530 or 1100 for time
days=$9 #e.g. "Tuesday,Friday"
miner="/usr/local/bin/cpuminer"

$miner -a x16r -o stratum+tcp://ravenminer.com:3336 -u RFG2SL3jtheTPg6c9GKUNzKmQQg6uNfegk -p c=RVN
