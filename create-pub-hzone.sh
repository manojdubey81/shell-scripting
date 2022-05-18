#!/bin/bash
# This Script will Create Public Hosted Zone

if [ -z "$1" ]; then
  echo -e '\e[32mPlease pass public hosted zone name too!\e[0m'
  exit 1
fi

COMPONENT=$1

PUB_HOST_ZONE=$(aws route53 create-hosted-zone --name "${COMPONENT}" --caller-reference "$(date)")

echo "---------------------------------"
echo "\e[32mPub_hosted-zone :" "${PUB_HOST_ZONE}\e[0m"

