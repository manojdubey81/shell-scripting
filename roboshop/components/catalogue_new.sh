#!/bin/bash

source components/common_new.sh

Print "Extract Yum Repo for NodeJS"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FIlE}
StatusChk $? "NodeJS Repo Extraction"

Print "Install NodeJS"
yum install nodejs gcc-c++ -y &>>${LOG_FIlE}
StatusChk $? "NodeJS Install"

Print "Add Deamon user"
useradd roboshop &>>${LOG_FIlE}
StatusChk $? "Deamon Useradd"

Print "Download catalogue archive"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FIlE}
StatusChk $? "catalogue archive downloaded"

Print "Extract and Load catalogue repo"
cd /home/roboshop && unzip -o /tmp/catalogue.zip &>>${LOG_FIlE} && mv catalogue-main catalogue
StatusChk $? "Extraction of catalogue"

Print "npm Install"
cd /home/roboshop/catalogue && npm install &>>${LOG_FIlE}
StatusChk $? "npm Install"

Print "Update mongodb private IP in SystemD file"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>{LOG_FIlE}
StatusChk $? "systemd file moved to default location"

sed -i -e '/MONGO_DNSNAME/mongodb private ip/' /etc/systemd/system/catalogue.service &>>{LOG_FIlE}
StatusChk $? "MONGO_DNSNAME Updated"

Print "Restart deamon"
systemctl daemon-reload &>>{LOG_FIlE} && systemctl restart catalogue &>>{LOG_FIlE} && systemctl enable catalogue &>>{LOG_FIlE}

echo -e "\e[32m Catalogue Ready to Use\e[0m"