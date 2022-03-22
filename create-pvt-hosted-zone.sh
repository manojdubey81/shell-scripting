#!/bin/bash

VPC_ID=$(aws ec2 describe-vpcs | jq '.Vpcs[].VpcId' | sed -e 's/"//g')
PVT_HOST_ZONE=$(aws route53 create-hosted-zone --name roboshop.internal --vpc VPCRegion="us-east-1",VPCId=${VPC_ID} --caller-reference "$(date)")

