#!/usr/bin/env bash

usage() {
    echo "Usage: $0 -n <service_name> -v <version> -e <endpoint> [-t <token>]" 1>&2
    exit 1
}

while getopts ":v:n:e:a:" arg; do
    case "${arg}" in
        v)
            version=${OPTARG}
            ;;
        n)
            name=${OPTARG}
            ;;
        e)
            endpoint=${OPTARG}
            ;;
        t)
            token=${OPTARG}
            ;;
        a)
            app=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${version}" ] || [ -z "${name}" ]; then
    usage
fi

[ -z "${endpoint}" ] && endpoint="localhost:8080"
[ -z "${token}" ] && token=$(/bin/cat token)
[ -z "${app}" ] && app="${name}"

auth_header="Authentication: Bearer ${token}"
content_type_header="Content-Type: application/json"
postdata="{\"application\": \"${app}\", \"name\": \"${name}\", \"version\": \"${version}\"}"

echo "POST to ${endpont}/deploy: $postdata"
curl -s -H "${auth_header}" -H "${content_type_header}" -d "${postdata}" "${endpoint}/deploy"


# wait for success
jq_filter=".services[] | select(.name==\"${name}\") | .status"
status=$(curl -s -H "${auth_header}" -H "${content_type_header}" "${endpoint}/status" | jq -r "${jq_filter}")
until [ "$status" == "green" ]; do
    echo "Waiting for deployment to enter running state before retrieving deploy status from environment operator"
    sleep 5
    status=$(curl -s -H "${auth_header}" -H "${content_type_header}" "${endpoint}/status" | jq -r "${jq_filter}")
done
