#!/bin/bash

# Verify all 6 containers run from startup
CONTAINERCOUNT=$(docker ps -q $1 -f status=running | wc -l)
CONTAINERSEXPECTED=6
SECONDS=0
SECONDSMAX=3000
SECONDSLIMIT=$(($SECONDSMAX+25))


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
        echo "Waiting for containers to start..."
        echo "$CONT_STATUS" |  sed -e 's/Up.* (/: /g' -e 's/)//g' | grep starting
        #check if only 1 container is still starting
        LINE_CHECK=$(echo -n "$CONT_STATUS" | grep -c '^')
        if [ $LINE_CHECK -eq 1 ]; then
            echo $LINE_CHECK
            docker-compose logs -f
        fi
    #exit with error if any container is in an unhealthy state
    elif printf '%s\n' "${CONT_STATUS[@]}" | grep -q 'unhealthy'; then
        echo "$CONT_STATUS" | grep "unhealthy" | sed -e 's/Up.*unhealthy)/Error: is unhealthy. /'
        docker-compose logs -f
        exit 1
    else
        echo "$CONT_STATUS"
        exit 0    
    fi

    sleep 20

    #exit with error if time greater than allowed
    if [[ $SECONDS -ge $SECONDSLIMIT ]]; then
    exit 1
    fi

done
