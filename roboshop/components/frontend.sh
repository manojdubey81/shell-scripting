#!/bin/bash

source components/common.sh

Print "Installing Nginx"
yum install nginx -y &>>$LOG_FILE
Statcheck $? "Nginx Installed-"

Print "Extract Nginx Repo"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
Statcheck $? "Nginx Extraction-"


Print "Cleanup Old Nginx"
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
Statcheck $? "Old Nginx Cleanup-"

cd /usr/share/nginx/html/


Print "Extract configuration"
unzip /tmp/frontend.zip && mv frontend-main/* . && mv static/* . &>>$LOG_FILE
Statcheck $? "Configuration Extraction-"

Print "RoboShop Configuration Update"
mv localhost.conf /etc/nginx/default.d/roboshop.conf  &>>$LOG_FILE
Statcheck $? "RoboShop Configuration Updated-"

Print "Start Nginx"
systemctl restart nginx && systemctl enable nginx &>>$LOG_FILE
Statcheck $? "Nginx Started"

echo -e "\e[32m Frontend Machine Ready to Use\e[0m"