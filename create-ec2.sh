#!/bin/bash

aws ec2 run-instances \
      --image-id ami-0bb6af715826253bf \
      --instance-type t2.micro \
      --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=My_script_ec2}]" :jq

