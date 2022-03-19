#!/bin/bash

if [ -z "$1" ]; then
  echo -e '\e[31m Machine Name Required\e[0m'
  exit 1
fi

COMPONENT="$1"

aws ec2 run-instances \
      --image-id ami-0bb6af715826253bf \
      --instance-type t2.micro \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
      | jq

