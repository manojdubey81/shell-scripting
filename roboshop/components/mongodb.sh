#!bin/bash

source components/common.sh

# Download Mongodb Configuration
Print "Download mongodb configuration"
curl -f -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo
Statcheck $? "Mongodb configuration Downloaded"

# Installing Mongodb
Print "Install Mongodb"
yum install -y mongodb-org
Statcheck $? "Mongodb Installation"

# Updating Listner IP
Print "Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file"
#Config file: `/etc/mongod.conf`
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
Statcheck $? "Listener IP Updated"

# Start Mongodb
Print "Start mongodb"
systemctl enable mongod && systemctl restart mongod
Statcheck $? "MongoDB Started"

## Every Database needs the schema to be loaded for the application to work.
Print "Download schema archive and load it"

curl -f -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
Statcheck $? "Schema archive downloaded"


cd /tmp
unzip mongodb.zip
cd mongodb-main

Print "Catalogue schema download"
mongo < catalogue.js
Statcheck $? "Catalogue schema installed"


Print "User schema download"
mongo < users.js
Statcheck $? "User schema installed"

echo -e "\e[32m MongoDB Ready to Use\e[0m"