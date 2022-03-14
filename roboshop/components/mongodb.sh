#!bin/bash

source components/common.sh

Print "Download mongodb repos"
curl -f -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
Statcheck $? "Mongodb repos Downloaded-"

Print "Install Mongodb"
yum install -y mongodb-org &>>$LOG_FILE
Statcheck $? "Mongodb Installation-"

Print "Update Listen IP"
#Config file: `/etc/mongod.conf`
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>LOG_FILE
Statcheck $? "Listener IP Updated-"

Print "Start mongodb"
systemctl enable mongod && systemctl restart mongod &>>LOG_FILE
Statcheck $? "MongoDB Started-"

Print "Download mongodb schema"
curl -f -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>LOG_FILE
Statcheck $? "Mongodb Schema Downloaded-"

Print "Extract mongodb schema"

cd /tmp && unzip -o mongodb.zip &>>LOG_FILE
Statcheck $? "Mongodb Schema Extracted-"


cd mongodb-main

for schema in catalogue users; do
  echo "Load $schema schema"
   mongo < ${schema}.js &>>LOG_FILE
   Statcheck $? "$schema schema installed"
done

echo -e "\e[32m MongoDB Ready to Use\e[0m"