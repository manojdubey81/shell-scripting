#!/bin/bash
# This Script will create required application instance
# If instance already running, the script will terminated and display the existance instance details
# Also create a private hosted zone(roboshop.internal)
# Insert "A" type record in private hosted zone


if [ -z "$1" ]; then
  echo -e '\e[32mPlease Select Component Name in first occurrence in command line after script!!\e[0m'
  exit 1
fi

if [ -z "$2" ]; then
  echo -e '\e[32mProvide Instances Type in second occurrence in after component name\e[0m  \e[34mi.e. t2.micro etc..\e[0m'
  exit 2
fi


COMPONENT="$1"
INST_TYPE="$2"

INST_NAME=$(aws ec2 describe-instances \
             --query "Reservations[*].Instances[*].{PublicIP:PublicIpAddress,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}" \
             --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values=${COMPONENT}" \
             --output text | awk '{print$1}')

PRIVATE_IP=$(aws ec2 describe-instances \
             --query "Reservations[*].Instances[*].{PrivateIP:PrivateIpAddress,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}" \
             --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values=${COMPONENT}" \
             --output text | awk '{print$2}')

PUBLIC_IP=$(aws ec2 describe-instances \
             --query "Reservations[*].Instances[*].{PublicIP:PublicIpAddress,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}" \
             --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values=${COMPONENT}" \
             --output text | awk '{print$2}')


if [ ! -z "${PRIVATE_IP}" ]; then
    echo  "  "
    echo -e "\e[31mThis Instance is already running, Please see below instance details:-\e[0m"
    echo -e "\e[33mName = ${INST_NAME}\e[0m, \e[32mPublicIP = ${PUBLIC_IP}\e[0m, \e[33mPrivateIp = ${PRIVATE_IP}\e[0m"
    echo -e "---------------------------------------------------------------------------------\n"
    exit 3
else
    echo  "  "
    echo -e "\e[33mInstance Creation Request is for ${COMPONENT} application\e[0m"
    echo -e "---------------------------------------------------------------\n"
fi



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
    echo -e "\e[1;32mInstance is/are in AMI ID = ${AMI_ID}\e[0m"
    echo -e "----------------------------------------------------\n"
fi


VPC_ID=$(aws ec2 describe-vpcs | jq '.Vpcs[].VpcId' | sed -e 's/"//g')

if [ -z "${VPC_ID}" ]; then
    echo -e "\e[1;31mUnable to locate VPC ID\e[0m"
    echo -e "----------------------------------------------------\n"
    exit 6
else
    echo -e "\e[1;32mVPC ID = ${VPC_ID}\e[0m"
    echo -e "----------------------------------------------------\n"

    PVT_HOST_ZONE=$(aws route53 create-hosted-zone \
                  --name "roboshop.internal" \
                  --vpc VPCRegion="us-east-1",VPCId=${VPC_ID} \
                  --caller-reference "$(date)" | jq '.HostedZone.Id' | sed -e 's/"//g' | sed -e 's/\/hostedzone\// /')

    if [ -z "${PVT_HOST_ZONE}" ]; then
        echo -e "\e[1;31mPrivate Hosted Zone Creation Filed\e[0m"
        echo -e "-------------------------------------------\n"
        exit 7
    else
        echo -e "\e[1;32mPrivate Hosted Zone ID = ${PVT_HOST_ZONE}\e[0m"
        echo -e "----------------------------------------------------\n"
    fi
fi


create_ec2()  {
  check_instance_existance
  if [ ! -z "${PRIVATE_IP}" ]; then
        echo  "  "
        echo -e "\e[31mThis Instance is already running, Please see below instance details:-\e[0m"
        echo -e "\e[33mName = ${INST_NAME}\e[0m, \e[32mPublicIP = ${PUBLIC_IP}\e[0m, \e[33mPrivateIp = ${PRIVATE_IP}\e[0m"
        echo -e "---------------------------------------------------------------------------------\n"
    else
        echo  "  "
        echo -e "\e[32mInstance Creation Request is for ${COMPONENT} application\e[0m"
        echo -e "---------------------------------------------------------------\n"
        assign_ec2
    fi
}

check_instance_existance(){
  INST_NAME=$(aws ec2 describe-instances \
               --query "Reservations[*].Instances[*].{PublicIP:PublicIpAddress,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}" \
               --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values=${COMPONENT}" \
               --output text | awk '{print$1}')

  PRIVATE_IP=$(aws ec2 describe-instances \
               --query "Reservations[*].Instances[*].{PrivateIP:PrivateIpAddress,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}" \
               --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values=${COMPONENT}" \
               --output text | awk '{print$2}')

  PUBLIC_IP=$(aws ec2 describe-instances \
               --query "Reservations[*].Instances[*].{PublicIP:PublicIpAddress,Name:Tags[?Key=='Name']|[0].Value,Status:State.Name}" \
               --filters "Name=instance-state-name,Values=running" "Name=tag:Name,Values=${COMPONENT}" \
               --output text | awk '{print$2}')
}

assign_ec2()  {
  PVT_IP=$(aws ec2 run-instances \
        --image-id "${AMI_ID}" \
        --instance-type "${INST_TYPE}" \
        --security-group-ids "${SG_ID}" \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
        | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

  sed -e "s/IPADDRESS/${PVT_IP}/" -e "s/COMPONENT/${COMPONENT}-dev/" -e "s/ACTION/UPSERT/" route53.json >/tmp/record.json
  aws route53 change-resource-record-sets --hosted-zone-id ${PVT_HOST_ZONE} --change-batch file:///tmp/record.json | jq
}


if [ "$1" == "all" ]; then
  for component in catalogue cart user shipping payment frontend mongodb mysql rabbitmq redis dispatch ; do
    COMPONENT=$component
    create_ec2
  done
else
  assign_ec2
fi
