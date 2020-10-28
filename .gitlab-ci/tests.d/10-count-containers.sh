#!/bin/bash

# Verify all 6 containers run from startup
CONTAINERCOUNT=$(docker ps -q $1 -f status=running | wc -l)
CONTAINERSEXPECTED=6
SECONDS=0
SECONDSMAX=3000
SECONDSLIMIT=$(($SECONDSMAX+25))


if [ $CONTAINERCOUNT -eq $CONTAINERSEXPECTED ]; then
echo "$CONTAINERCOUNT containers expected. $CONTAINERSEXPECTED containers found..."
elif [ $CONTAINERCOUNT -ne $CONTAINERSEXPECTED ]; then
echo "$CONTAINERCOUNT containers expected. $CONTAINERSEXPECTED containers found..."
exit 1 
fi


#CONTAINER_STATUS=$(docker ps --format '{{.Names}} {{.Status}}' | sed -e 's/Up.* (/: /g' -e 's/)//g' | grep starting)

while [ $SECONDS -le $SECONDSLIMIT ]
do
    CONT_STATUS=$(docker ps --format '{{.Names}} {{.Status}}')
        #looks for unhealthy|starting containers
    if printf '%s\n' "${CONT_STATUS[@]}" | grep -q 'starting'; then
        echo "Waiting for containers to start..."
        STARTING_CONT=$(echo "$CONT_STATUS" |  sed -e 's/Up.* (/: /g' -e 's/)//g' | grep starting)
        echo "$STARTING_CONT"
        #check if 3 or less containers running and then print docker logs
        LINE_CHECK=$(echo -n "$STARTING_CONT" | grep -c '^')
        if (( $LINE_CHECK <= 3 )); then
            docker-compose logs -f
        fi
    #exit with error if any container is in an unhealthy state
    elif printf '%s\n' "${CONT_STATUS[@]}" | grep -q 'unhealthy'; then
        echo "$CONT_STATUS" | grep "unhealthy" | sed -e 's/Up.*unhealthy)/Error: is unhealthy. /'
        docker-compose logs --tail="100"
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
