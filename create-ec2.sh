#!/bin/bash

if [ -z "$1" ]; then
  echo -e '\e[32mPlease Select Machine Name:\e[0m'
  echo -e '\e[33m1) frontend\t\t2) mongodb\t\t 3) catalogue\e[0m'
  echo -e '\e[33m4) redis\t\t5) user\t\t 6) cart\e[0m'
  echo -e '\e[33m7) mysql\t\t8) shipping\t\t 9) rebbitmq\e[0m'
  echo -e '\e[33m10) payment\t\t11) dispatch\t\t 12) all\e[0m'
  read -p "Enter your choice : " choice
  if [ "${choice}" == "1" ]; then
    sed -i -e 's/$choice/frontend/g' > name
  exit 1
fi

echo "your select machine is: " $name

#catalogue cart user shipping payment frontend mongodb mysql rabbitmq redis dispatch
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
