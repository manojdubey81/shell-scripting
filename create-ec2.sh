#!/bin/bash

create-ec2 () {
  aws ec2 run-instances \
      --image-id ami-0bb6af715826253bf \
      --instance-type t2.micro
}