#!/bin/bash

if [ -z "$1" ]; then
  echo -e '\e[32mPlease Select Machine Name:\e[0m'
  echo -e '\e[33\t1) frontend\t\t2) catalogue\t\t 12) all\e[0m'
  exit 1
fi

if [ -z "$2" ]; then
  echo -e '\e[34mProvide Instances Type like t2.micro etc..\e[0m'
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

if [ -z "${AMI_ID}" ]; then
    echo -e "\e[1;31mUnable to find Image AMI_ID\e[0m"
    exit
else
    echo -e "\e[1;32mAMI ID = ${AMI_ID}\e[0m"
fi


create_ec2()  {
  aws ec2 run-instances \
        --image-id "${AMI_ID}" \
        --instance-type "${INST_TYPE}" \
        --security-group-ids "${SG_ID}" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
        | jq
}


# IPADDRESS=$(aws ec2 describe-instances | jq '.Reservations[].Instances[].PrivateIpAddress' | sed -e 's/"//g')


if [ "$1" == "all" ]; then
  for component in catalogue cart user shipping payment frontend mongodb mysql rabbitmq redis dispatch ; do
    COMPONENT=$component
    create_ec2
  done
else
  create_ec2
fi
