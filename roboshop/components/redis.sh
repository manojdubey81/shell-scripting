#!/bin/bash

source components/common.sh

# Redis is used for in-memory data storage and allows users to access the data over API.

Print "Download Redis archive"

curl -f -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo
Statuschk $? "Redis archive downloaded"

Print "Install Redis"
yum install redis -y
Statuschk $? "Redis Installation"

Print "Update BindIP"

sed -i -e 'r/127.0.0.1/0.0.0.0/'  /etc/redis.conf && 'r/127.0.0.1/0.0.0.0/'  /etc/redis/redis.conf
Statuschk $? "BindIP Updated"


Print "Start Redis Database"

systemctl enable redis && systemctl start redis
Statuschk $? "Redis DB started"

echo -e "\e[32m Redis Ready to Use\e[0m"