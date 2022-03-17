#!/bin/bash

source components/common_new.sh

Print "Download Yum Repos"
curl -f -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG_FILE}
StatusChk $? "Repos downloaded"

Print "Install Redis"
yum install redis -y &>>${LOG_FILE}


Print "Update Redis Config"
if [ -f /etc/redis.conf ]; then
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>${LOG_FILE}
fi

if [ -f /etc/redis/redis.conf ]; then
  sed -i -e 's/127.0.0.1/0.0.0.0/' //etc/redis/redis.conf &>>${LOG_FILE}
fi
SatusChk $? "Redis Config Update"


Print "Start Redis Database"
systemctl enable redis &>>${LOG_FILE} &&  systemctl restart redis &>>${LOG_FILE}
StatusChk $? "Redis Started"