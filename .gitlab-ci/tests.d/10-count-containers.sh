#!/bin/bash

# Verify all 6 containers run from startup
CONTAINERCOUNT=$(docker ps -q $1 -f status=running | wc -l)
CONTAINERSEXPECTED=6
SECONDS=0
SECONDSMAX=300

while [ $CONTAINERCOUNT -eq $CONTAINERSEXPECTED ] || [ $SECONDS -le $SECONDSMAX ]
do
function countContainers() {
    CONTAINERCOUNT=$(docker ps -q $1 -f status=running | wc -l)
    echo "$CONTAINERCOUNT containers found. $CONTAINERSEXPECTED containers expected..."
    echo "Retrying container check. Sleeping 20 seconds..."
    TIMEREMAINING=$(($SECONDSMAX-$SECONDS))
    if [ $TIMEREMAINING -ne $SECONDSMAX ]; then
        echo "$TIMEREMAINING more seconds allowed for test..."
    fi
    if [ $CONTAINERCOUNT -eq $CONTAINERSEXPECTED ]; then
        exit
    fi

    sleep 20
}
countContainers
done

   if [ $SECONDS -ge $SECONDSMAX ]; then
        echo "Time limit exceeded. 300 seconds are allowed for test!"
        exit 1
   fi

exit 0