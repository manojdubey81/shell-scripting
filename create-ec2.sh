#!/bin/bash

if [ -z "$1" ]; then
  echo -e '\e[34mMachine Name Required\e[0m'
  exit 1
fi

if [ -z "$2" ]; then
  echo -e '\e[34mInstance type must needed\e[0m'
  exit 2
fi


COMPONENT="$1"
INST_TYPE="$2"

SG_ID=$(aws ec2 describe-security-groups \
        --filters Name=group-name,Values=allow-all-sgp \
          | jq '.SecurityGroups[].GroupId' \
          | sed -e 's/"//g')

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" \
        | jq '.Images[].ImageId' | sed -e 's/"//g')

VPC_ID=$(aws ec2 describe-vpcs | jq '.Vpcs[].VpcId' | sed -e 's/"//g')


aws ec2 run-instances \
      --image-id "${AMI_ID}" \
      --instance-type "${INST_TYPE}" \
      --security-group-ids "${SG_ID}" \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
      | jq

PUB_HOST_ZONE=$(aws route53 create-hosted-zone --name roboshop.com --caller-reference "$(date)")
PVT_HOST_ZONE=$(aws route53 create-hosted-zone --name roboshop.internal --vpc VPCRegion="us-east-1",VPCId=${VPC_ID} --caller-reference "$(date)")

