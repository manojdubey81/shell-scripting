#!/bin/bash

PUB_HOST_ZONE=$(aws route53 create-hosted-zone --name roboshop.com --caller-reference "$(date)")

