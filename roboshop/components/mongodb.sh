#!/bin/bash

source components/common.sh

Print "Download Yum Repos for MongoDB"
curl -f -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG_FILE}
StatusChk $? "MongoDB Repo Downloaded"

Print "Install MongoDB"
yum install -y mongodb-org &>>${LOG_FILE}
StatusChk $? "MongoDB Installation"

Print "Update Listen IP"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG_FILE}
StatusChk $? "Listner IP Update"

Print "Start mongoDB"
systemctl enable mongod &>>${LOG_FILE} && systemctl restart mongod &>>${LOG_FILE}
StatusChk $? "MongoDB Started"


Print "Download the schema"
curl -f -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>${LOG_FILE}
StatusChk $? "Schema Downloaded"

Print "Extracted schema"
cd /tmp && unzip -o mongodb.zip &>>{LOG_FILE}
StatusChk $? "Schema Extracted"

Print "Schema Download"
cd mongodb-main
for schema in catalogue users; do
  echo "Load $schema schema"
  mongo < ${schema}.js &>>${LOG_FILE}
  StatusChk $? "${schema} Schema Downloaded"
done

echo -e "\e[32m MongoDB Ready to Use\e[0m"

