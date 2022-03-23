#!/bin/bash

if [ -z "$1" ]; then
  echo -e '\e[32mPlease Select Machine Name to add in pvt hosted zone:\e[0m'
  exit 1
fi

COMPONENT="$1"

PRIVATE_IP=$(aws ec2 describe-instances \
        --filters "Name=tag:Name,Values=${COMPONENT}" \
        --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)