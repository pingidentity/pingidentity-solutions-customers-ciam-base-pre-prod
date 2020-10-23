#!/bin/bash

# Verify all 6 containers run from startup
CONTAINERCOUNT=$(docker ps -q $1 -f status=running | wc -l)
SECONDS=0
SECONDSMAX=300

while [ $CONTAINERCOUNT -lt 6 -o $SECONDS -lt 300 ]
do
function countContainers() {
    CONTAINERCOUNT=$(docker ps -q $1 -f status=running | wc -l)
    echo "$CONTAINERCOUNT containers found. 6 containers expected..."
    TIMEREMAINING=$(($SECONDSMAX-$SECONDS))
    if [ $TIMEREMAINING -ne 300 ]; then
        echo "$TIMEREMAINING more seconds allowed for test..."
    fi
    if [ $CONTAINERCOUNT -eq 6 -o $SECONDS -eq 300 ]; then
        exit
    fi
    sleep 60
}
countContainers
done