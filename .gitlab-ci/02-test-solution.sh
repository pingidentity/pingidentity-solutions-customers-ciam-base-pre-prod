#!/bin/bash

# Verify if server profile directories exist
PINGCENTRALDIR="./server-profile/pingcentral"
PINGDATASYNCDIR="./server-profile/pingdatasync"
PINGDELEGATORDIR="./server-profile/pingdelegator"
PINGDIRECTORYDIR="./server-profile/pingdirectory"
PINGFEDERATEDIR="./server-profile/pingfederate"

declare -a server_profiles=($PINGCENTRALDIR
                            $PINGDATASYNCDIR
                            $PINGDELEGATORDIR
                            $PINGDIRECTORYDIR
                            $PINGFEDERATEDIR
                            )

for server_profile in "${server_profiles[@]}"
do
    if [ -z "$(ls -A $server_profile)" ]; then
        echo "$server_profile does not exist or does not contain any content" | sed -e 's@./server-profile/@@'
    else
        echo "$server_profile directory does exist and contains content" | sed -e 's@./server-profile/@@'
    fi
done


docker ps --format "{{.Names}}"


# Verify Sample Users were created successfully in PingDirectory
echo "Verifying Sample Users were created successfully in PingDirectory"
USERSTATUS=$(curl --insecure --location -s -o /dev/null -w '%{http_code}' --request GET 'https://localhost:1443/directory/v1/uid=cdeacon,ou=People,dc=example,dc=com' \
--header 'Authorization: Basic YWRtaW5pc3RyYXRvcjoyRmVkZXJhdGVNMHJl' \
--header 'Content-Type: application/json' \
--data-raw '{
  "filter": "objectClass eq \"person\"",
  "searchScope": "wholeSubtree",
  "limit": 25,
  "includeAttributes": "*,_operationalAttributes",
  "excludeAttributes": "sn,isMemberOf"
}')
  if [ $USERSTATUS -eq 200 ]; then
    echo "Received Status Code: $USERSTATUS. Test Users verified successfully."
  else
    echo "Received Status Code: $USERSTATUS. Test Users could NOT be verified successfully."
  fi


# Verify PingDirectory is setup in PingFederate as a Data Store
echo "Verifying PingDirectory is setup in PingFederate as a Data Store..."
DIRSTATUS=$(curl --insecure --location -s -o /dev/null -w '%{http_code}' --request GET 'https://localhost:9999/pf-admin-api/v1/dataStores/LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3' \
--header 'X-XSRF-Header: PingFederate' \
--header 'Authorization: Basic YWRtaW5pc3RyYXRvcjoyRmVkZXJhdGVNMHJl')
  if [ $DIRSTATUS -eq 200 ]; then
    echo "Received Status Code: $DIRSTATUS. PingDirectory is connected to PingFederate."
  else
    echo "Received Status Code: $DIRSTATUS. PingDirectory is NOT connected to PingFederate."
  fi

# Verify Sample SAML Connection is Setup in PingFederate
echo "Verifying Sample SAML Connection is configured in PingFederate..."
SAMLSTATUS=$(curl --insecure --location -s -o /dev/null -w '%{http_code}' --request GET 'https://localhost:9999/pf-admin-api/v1/idp/spConnections?entityId=https%3A%2F%2Fhttpbin.org' \
--header 'X-XSRF-Header: PingFederate' \
--header 'Authorization: Basic YWRtaW5pc3RyYXRvcjoyRmVkZXJhdGVNMHJl')
  if [ $SAMLSTATUS -eq 200 ]; then
    echo "Received Status Code: $SAMLSTATUS. Sample SAML Connection is setup in PingFederate."
  else
    echo "Received Status Code: $SAMLSTATUS. Sample SAML Connection is NOT setup in PingFederate."
  fi

# Verify OAuth is Setup in PingFederate
echo "Verifying OAuth is Setup in PingFederate..."
OAUTHSTATUS=$(curl --insecure --location -s -o /dev/null -w '%{http_code}' --request GET 'https://localhost:9999/pf-admin-api/v1/oauth/clients' \
--header 'X-XSRF-Header: PingFederate' \
--header 'Authorization: Basic YWRtaW5pc3RyYXRvcjoyRmVkZXJhdGVNMHJl')
  if [ $OAUTHSTATUS -eq 200 ]; then
    echo "Received Status Code: $OAUTHSTATUS. OAuth is setup in PingFederate."
  else
    echo "Received Status Code: $OAUTHSTATUS. OAuth is NOT setup in PingFederate."
  fi