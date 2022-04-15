#!/bin/bash

if [ -z "$1" ]; then
  echo -e '\e[32mPlease Select Machine Name to add in pvt hosted zone:\e[0m'
  exit 1
fi

if [ -z "$2" ]; then
  echo -e '\e[32mPlease provide env name like Dev/Prod/Test:\e[0m'
  exit 1
fi

COMPONENT="$1"
HOSTED_ZNAME="$2"

PRIVATE_IP=$(aws ec2 describe-instances \
        --filters "Name=tag:Name,Values=${COMPONENT}" \
        --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)

HOSTED_ZONE=$(aws route53 list-hosted-zones | grep hostedzone | sed -e 's/"Id": "//g' | sed -e 's/",//g')

aws --profile messa route53 change-resource-record-sets \
    --hosted-zone-id "${HOSTED_ZONE}" \
    --change-batch \
    '{"Changes": [ { "Action": "UPSERT", "ResourceRecordSet": \
    { "Name": "$(HOSTED_ZNAME}", "Type": "A", "TTL": 300, "ResourceRecords": \
    [{ "Value": "${PRIVATE_IP}" }] } } ]}'

