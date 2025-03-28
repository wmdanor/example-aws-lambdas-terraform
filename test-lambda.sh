#!/bin/bash

set -e

usage="$0 <function-name> <payload-json>"

fn=$1
payload=$2

if [ -z "$fn" ]; then
echo "Usage: $usage. Missing <function-name>"
exit 1
fi

if [ -z "$payload" ]; then
echo "Usage: $usage. Missing <payload-json>"
exit 1
fi

aws lambda invoke --function-name ${fn} \
    --payload '{"message": "Hello"}' \
    --cli-binary-format raw-in-base64-out \
    temp --no-cli-pager

cat temp

rm temp
