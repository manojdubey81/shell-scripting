#!/bin/bash

source components/common_new.sh

Print "Install Nginx"
yum install nginx -y &>>${LOG_FILE}
StatusChk $? "Nginx Install"

Print "Download frontend archive"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>${LOG_FILE}
StatusChk $? "Frontend Yum Repo Extract"

Print "Clean Old Nginx"
rm -rf /usr/share/nginx/html/* &>>${LOG_FILE}
StatusChk $? "Clean Old Nginx repo"

Print "Deploy in Nginx Default Location"
cd /usr/share/nginx/html &>>${LOG_FILE} && unzip -o /tmp/frontend.zip &>>${LOG_FILE} && mv frontend-main/* . &>>${LOG_FILE} && mv static/* . &>>${LOG_FILE}
StatusChk $? "Nginx Deplyement"

Print "Move config to default location"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>${LOG_FILE}
StatusChk $? "Nginx Default Location Setup"

Print "Update config file"
sed -i -e '/catalogue/s/localhost/172.31.85.219/' \
          /etc/nginx/default.d/roboshop.conf &>>${LOG_FILE}
StatusChk $? "Configuration Updated"

Print "Restart Nginx"
systemctl enable nginx &>>${LOG_FILE} && systemctl restart nginx &>>${LOG_FILE}
StatusChk $? "Nginx Restart"

echo -e "\e[34m Nginx Machine Ready\e[0m"
