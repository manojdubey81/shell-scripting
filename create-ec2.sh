#!/bin/bash

if [ -z "$1" ]; then
  echo -e '\e[32mPlease Select Component Name!!\e[0m'
  exit 1
fi

if [ -z "$2" ]; then
  echo -e '\e[34mProvide Instances Type like t2.micro etc..\e[0m'
  exit 2
fi


COMPONENT="$1"
INST_TYPE="$2"

PRIVATE_IP=$(aws ec2 describe-instances \
        --filters "Name=tag:Name,Values=${COMPONENT}" \
        --query 'Reservations[*].Instances[*].PrivateIpAddress' --output text)

if [ ! -z "${PRIVATE_IP}" ]; then
    echo  "  "
    echo -e  "\e[33mInstance ${COMPONENT} is already exists, Please check\e[0m"
    echo -e "----------------------------------------------------\n"
    exit 3
else
    echo  "  "
    echo -e  "\e[33mRequested Instance is ${COMPONENT}\e[0m"
    echo -e "----------------------------------------------------\n"
fi

IPADDRESS=$(aws ec2 describe-instances \
            | jq '.Reservations[].Instances[].PrivateIpAddress' \
            | sed -e 's/"//g')

echo "IPADDRESS : " $IPADDRESS

SG_ID=$(aws ec2 describe-security-groups \
          --filters Name=group-name,Values=allow-all-sgp \
            | jq '.SecurityGroups[].GroupId' \
            | sed -e 's/"//g')

if [ -z "{SG_ID}" ] ; then
    echo -e "\e[1;33m Security Group allow-all-sgp does not exist"
    echo -e "----------------------------------------------------\n"
    exit 4
else
    echo -e "\e[1;32mSecurity GroupId = ${SG_ID}\e[0m"
    echo -e "----------------------------------------------------\n"
fi

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" \
        | jq '.Images[].ImageId' | sed -e 's/"//g')

if [ -z "${AMI_ID}" ]; then
    echo -e "\e[1;31mUnable to find Image AMI_ID\e[0m"
    echo -e "----------------------------------------------------\n"
    exit 5
else
    echo -e "\e[1;32mAMI ID = ${AMI_ID}\e[0m"
    echo -e "----------------------------------------------------\n"
fi


create_ec2()  {
  aws ec2 run-instances \
        --image-id "${AMI_ID}" \
        --instance-type "${INST_TYPE}" \
        --security-group-ids "${SG_ID}" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
        | jq
}





if [ "$1" == "all" ]; then
  for component in catalogue cart user shipping payment frontend mongodb mysql rabbitmq redis dispatch ; do
    COMPONENT=$component
    create_ec2
  done
else
  create_ec2
fi