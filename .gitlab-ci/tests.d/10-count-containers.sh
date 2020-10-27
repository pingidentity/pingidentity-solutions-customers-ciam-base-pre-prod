#!/bin/bash

# Verify all 6 containers run from startup
CONTAINERCOUNT=$(docker ps -q $1 -f status=running | wc -l)
CONTAINERSEXPECTED=6
SECONDS=0
SECONDSLIMIT=3000


if [ $CONTAINERCOUNT -eq $CONTAINERSEXPECTED ]; then
echo "$CONTAINERCOUNT containers found. $CONTAINERSEXPECTED containers expected..."
elif [ $CONTAINERCOUNT -ne $CONTAINERSEXPECTED ]; then
echo "$CONTAINERCOUNT containers found. $CONTAINERSEXPECTED containers expected..."
exit 1 
fi


#CONTAINER_STATUS=$(docker ps --format '{{.Names}} {{.Status}}' | sed -e 's/Up.* (/: /g' -e 's/)//g' | grep starting)

while [ $SECONDS -le $SECONDSLIMIT ]
do
    CONT_STATUS=$(docker ps --format '{{.Names}} {{.Status}}')
        #looks for unhealthy|starting containers
    if printf '%s\n' "${CONT_STATUS[@]}" | grep -q 'starting'; then
        echo "$CONT_STATUS" |  sed -e 's/Up.* (/: /g' -e 's/)//g' | grep starting
    elif printf '%s\n' "${CONT_STATUS[@]}" | grep -q 'unhealthy'; then
        echo "$CONT_STATUS" | grep "unhealthy" | sed -e 's/: unhealthy/experienced a problem/'
        exit 1
    else
        echo "$CONT_STATUS"
        exit 0    
    fi

    sleep 20

done