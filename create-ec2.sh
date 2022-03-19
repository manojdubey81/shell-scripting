#!/bin/bash

create-ec2 () {
  aws ec2 run-instances \
      --image-id ami-0abcdef1234567890 \
      --instance-type t2.micro
}