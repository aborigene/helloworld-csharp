#!/bin/bash
cd /app

echo "Starting app"
/bin/bash entrypoint.sh &

#echo "Sleeping 20s"
#sleep 20

echo "Listing logs"

while [ true ]
do
    for f in `ls /opt/dynatrace/oneagent/log` 
    do
        echo "Reading $f"
        cat "/opt/dynatrace/oneagent/log/$f"
    done

    for f in `ls /opt/dynatrace/oneagent/log/dotnet` 
    do
        echo "Reading $f"
        cat "/opt/dynatrace/oneagent/log/dotnet/$f"
    done
    sleep 120
    
done
