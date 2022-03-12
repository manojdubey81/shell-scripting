#!bin/bash

# Validate user root privelage
USER_ID=$(id -u)

if [ "$USER_ID" -ne 0 ]; then
  echo -e "\e[31m You need root access to execute this script\e[0m"
  exit 1
fi

# Download Mongodb COnfiguration
echo -e "\e[35m Download Get mongodb configuration\e[0m"
curl -f -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo

if [ "$?" -eq 0 ]; then
  echo -e "\e[32m Download Get mongodb configuration Success\e[0m"
else
  echo -e "\e[31m Download Get mongodb configuration Failed\e[0m"
  exit 2
fi

# Installing Mongodb
echo -e "\e[35m Install Mongodb\e[0m"
yum install -y mongodb-org

if [ "$?" -eq 0 ]; then
  echo -e "\e[32m Installing Mongod Success\e[0m"
else
  echo -e "\e[31m Installing Mongod Failed\e[0m"
  exit 2
fi

# Updating Listner IP
echo -e "\e[35m Update Listen IP address from 127.0.0.1 to 0.0.0.0 in config file\e[0m"
#Config file: `/etc/mongod.conf`
sed -i -e "s/127.0.0.1/0.0.0.0" /etc/mongod.conf

if [ "$?" -eq 0 ]; then
  echo -e "\e[32m Listen IP Update Success\e[0m"
else
  echo -e "\e[31m Listen IP Update Failed\e[0m"
  exit 2
fi

# Start Mongodb
echo -e "\e[35m Start mongodb\e[0m"

systemctl enable mongod

if [ "$?" -eq 0 ]; then
  echo -e "\e[32m Mongod enable Success\e[0m"
else
  echo -e "\e[31m Mongod enable  Mongod Failed\e[0m"
  exit 2
fi

systemctl restart mongod

if [ "$?" -eq 0 ]; then
  echo -e "\e[32m Mongod Start  Success\e[0m"
else
  echo -e "\e[31m Mongod Start Failed\e[0m"
  exit 2
fi


## Every Database needs the schema to be loaded for the application to work.
echo -e "\e[35m Download the schema and load it\e[0m"

curl -f -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"

if [ "$?" -eq 0 ]; then
  echo -e "\e[32m mongodb schema download Success\e[0m"
else
  echo -e "\e[31m mongodb schema download  Failed\e[0m"
  exit 2
fi

cd /tmp
unzip mongodb.zip
cd mongodb-main

echo -e "\e[35m Catalogue schema download\e[0m"
mongo < catalogue.js

if [ "$?" -eq 0 ]; then
  echo -e "\e[32m Catalogue schema download Success\e[0m"
else
  echo -e "\e[31m Catalogue schema download Failed\e[0m"
  exit 2
fi

echo -e "\e[35m User schema download\e[0m"
mongo < users.js

if [ "$?" -eq 0 ]; then
  echo -e "\e[32m Catalogue schema download Success\e[0m"
else
  echo -e "\e[31m Catalogue schema download Failed\e[0m"
  exit 2
fi

echo -e "\e[32m MongoDB Ready to Use\e[0m"