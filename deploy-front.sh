#!/usr/bin/env bash

TOKEN=$(/bin/cat token)
svc="front"
version=${1:-"latest"}
url="http://localhost:8080"
auth_header="Authentication: Bearer ${TOKEN}"
content_type_header="Content-Type: application/json"

postdata="{\"application\": \"sample-app-${svc}\", \"name\": \"${svc}\", \"version\": \"${version}\"}"
echo $postdata

curl -s -H "${auth_header}" -H "${content_type_header}" -d "${postdata}" "${url}/deploy"

jq_filter=".services[] | select(.name==\"${svc}\") | .status"

status=$(curl -s -H "${auth_header}" -H "${content_type_header}" "${url}/status" | jq -r "${jq_filter}")

while [ "$status" != "green" ]; do
    echo "Waiting for deployment to enter running state before retrieving deploy status from environment operator"
    sleep 5
    status=$(curl -s -H "${auth_header}" -H "${content_type_header}" "${url}/status" | jq -r "${jq_filter}")
done
