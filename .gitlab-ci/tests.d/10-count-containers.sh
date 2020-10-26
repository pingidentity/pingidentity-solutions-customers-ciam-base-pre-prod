#!/bin/bash

# Verify all 6 containers run from startup
CONTAINERCOUNT=$(docker ps -q $1 -f status=running | wc -l)
CONTAINERSEXPECTED=6
SECONDS=0
SECONDSMAX=60
SECONDSLIMIT=$(($SECONDSMAX+25))

while [ $SECONDS -le $SECONDSLIMIT ]
do
function countContainers() {
    CONTAINERCOUNT=$(docker ps -q $1 -f status=running | wc -l)
    if [ $CONTAINERCOUNT -eq $CONTAINERSEXPECTED ]; then
        echo "$CONTAINERCOUNT containers found. $CONTAINERSEXPECTED containers expected..."
        exit 0
    fi
        echo "$CONTAINERCOUNT containers found. $CONTAINERSEXPECTED containers expected..."
        TIMEREMAINING=$(($SECONDSMAX-$SECONDS))
    if [ $SECONDS -le $SECONDSMAX ]; then
        echo "$TIMEREMAINING more seconds allowed for test..."
    else
        echo "Time limit exceeded. $SECONDSMAX seconds are allowed for test!"
        exit 1
    fi

    sleep 20
}
countContainers
done

exit 0