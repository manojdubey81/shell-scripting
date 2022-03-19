#!/bin/bash

if [ -z "$1" ]; then
  echo -e '\e[34mMachine Name Required\e[0m'
  exit 1
fi

COMPONENT="$1"

aws ec2 run-instances \
      --image-id ami-0bb6af715826253bf \
      --instance-type t2.micro \
      --security-group-ids ${SG_ID} \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
      | jq


SG_ID=$(aws ec2 describe-security-groups \
        --filters Name=group-name,Values=allow-all-sgp \
          | jq '.SecurityGroups[].GroupId' \
          | sed -e 's/"//g')
