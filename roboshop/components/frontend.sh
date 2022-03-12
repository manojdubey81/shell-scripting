#!/bin/bash

source components/common.sh

Print "Installing Nginx"
yum install nginx -y
Statcheck $?

Print "Download nginx content"

curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
Statcheck $?


Print "Cleanup Old Nginx Content"
rm -rf /usr/share/nginx/html/*
Statcheck $?


cd /usr/share/nginx/html/

unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .

Print "Update RoboShop Configuration"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
Statcheck $?

Print "Start Nginx"
systemctl restart nginx
systemctl enable nginx
Statcheck $?