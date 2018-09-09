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
miner="./xmrig"

if [ ${#poolUser} -lt 50 ]; then
    echo "poolUser is not valid"; exit;
fi;

if [ "$maxCpu" != "100" ] && [ "$maxCpu" != "50" ] && [ "$maxCpu" != "25" ] && [ "$maxCpu" != "12.5" ] && [ "$maxCpu" != "6.25" ] ; then
    echo "maxCpu is not valid"; exit;
fi;

if [ "$useScheduler" != "true" ] && [ "$useScheduler" != "false" ]; then
    echo "useScheduler is not valid, use true or false"; exit;
fi;

if ! [[ ${poolUrl} =~ .+\.[a-z]+\:[0-9]+ ]]; then
    echo "The URL Format seams not right."; exit;
fi;

if [ "$useScheduler" == "true" ]; then

        if [ ${#startTime} -ne 4 ]; then
                echo "startTime is not in a valid format"; exit;
        fi;
        if [[ ${startTime} =~ [A-Za-z_\;\:\.]+ ]]; then
            echo "startTime can only contain digits"; exit;
        fi;
        if [ ${#stopTime} -ne 4 ]; then
                echo "stopTime is not in a valid fromat"; exit;
        fi;
        if [[ ${stopTime} =~ [A-Za-z_\;\:\.]+ ]]; then
            echo "stoptimeTime can only contain digits"; exit;
        fi;

        IFS=',' read -r -a dayArray <<< "$days"
        for day in "${dayArray[@]}"
    do
        if [ "${day,,}" != "monday" ] && [ "${day,,}" != "tuesday" ] && [ "${day,,}" != "wednesday" ] && [ "${day,,}" != "thursday" ] && [ "${day,,}" != "friday" ] && [ "${day,,}" != "saturday" ] && [ "${day,,}" != "sunday" ]; then
                echo "Days are not formated correctley."; exit;
        fi;
    done

        # wait for starttime
        echo "================================================================";
        echo "Scheduler information";
        echo "At: $startTime - $stopTime";
        echo "On: $days";
        echo "================================================================";

        echo "Waiting for the next work schedule....";

        while { printf -v current_day '%(%A)T' -1 && [[ ${days,,} != *"${current_day,,}"* ]]; } || { printf -v current_time '%(%H%M)T' -1 && [[ ${current_time} != ${startTime} ]]; }; do
                sleep 10;
		echo "Current Time: $current_time";
        done;

        echo "Time to work, miner is signing-on!";
        # run xmrig as background
        $miner -a "$algoMode" -o "$poolUrl" -u "$poolUser" -p "$poolPW" --max-cpu-usage="$maxCpu" &

        while printf -v current_time '%(%H%M)T' -1 && [[ $current_time != $stopTime ]]; do
                sleep 10;
        done;

        # end the xmring when the stoptime is reached
        pkill xmrig;
        echo "Miner signing-off and preparing for  the next work schedule!";
        "$0" "$algoMode" "$poolUrl" "$poolUser" "$poolPW" "$maxCpu" "$useScheduler" "$startTime" "$stopTime" "$days";
        exit;
else
         $miner -a "$algoMode" -o "$poolUrl" -u "$poolUser" -p "$poolPW" --max-cpu-usage="$maxCpu"
fi;
