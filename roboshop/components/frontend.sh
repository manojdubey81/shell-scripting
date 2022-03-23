#!/bin/bash

source components/common.sh

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

Print "Update RoboShop Configuration"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
for component in catalogue user cart shipping payment dispatch; do
  echo -e "Updating $component in Configuration"
  sed -i -e "/${component}/s/localhost/${component}.roboshop.internal/"  /etc/nginx/default.d/roboshop.conf
  StatusChk $? "Configuration Updated"
done

Print "Restart Nginx"
systemctl enable nginx &>>${LOG_FILE} && systemctl restart nginx &>>${LOG_FILE}
StatusChk $? "Nginx Restart"

#Readymsg