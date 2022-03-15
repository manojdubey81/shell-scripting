#!/bin/bash

source components/common_new.sh

Print "Configure Yum repos"
  curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>"${LOG_FILE}"
StatusChk $? "NodeJS Repo Extraction"

Print "Install NodeJS"
  yum install nodejs gcc-c++ -y &>>"${LOG_FILE}"
StatusChk $? "NodeJS Install"

Print "Add Deamon user"
useradd roboshop &>>"${LOG_FILE}"
StatusChk $? "Deamon Useradd"

Print "Download catalogue archive"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>"${LOG_FILE}"
StatusChk $? "catalogue archive downloaded"

Print "Extract and Load catalogue repo"
cd /home/roboshop && unzip -o /tmp/catalogue.zip &>>"${LOG_FILE}" && mv catalogue-main catalogue &>>"${LOG_FILE}"
StatusChk $? "Extraction of catalogue"

Print "npm Install"
cd /home/roboshop/catalogue && npm install &>>"${LOG_FILE}"
StatusChk $? "npm Install"

Print "Update mongodb private IP in SystemD file"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>"${LOG_FILE}"
StatusChk $? "systemd file moved to default location"

sed -i -e '/MONGO_DNSNAME/mongodb private ip/' /etc/systemd/system/catalogue.service &>>"${LOG_FILE}"
StatusChk $? "MONGO_DNSNAME Updated"

Print "Restart deamon"
systemctl daemon-reload &>>"${LOG_FILE}" && systemctl restart catalogue &>>"${LOG_FILE}" && systemctl enable catalogue &>>"${LOG_FILE}"

echo -e "\e[32m Catalogue Ready to Use\e[0m"