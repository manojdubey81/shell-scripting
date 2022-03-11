#!/bin/bash
#frontend

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo -e "\e[31mYou should be sudo or root user to run this script as\e[0m"
  exit 1
fi

echo -e "\e[36m Installing Nginx\e[0m"
yum install nginx -y

if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
else
  echo -e "\e[31mFAILURE\e[0m"
  exit 2
fi


echo -e "\e[36m Download nginx content\e[0m"

curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
else
  echo -e "\e[31mFAILURE\e[0m"
  exit 2
fi

echo -e "\e[36m Cleanup Old Nginx Content and Extract new downloaded archive \e[0m"

cd /usr/share/nginx/html/
rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

if [ $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
else
  echo -e "\e[31mFAILURE\e[0m"
  exit 2
fi

echo -e "\e[36m Restart Nginx\e[0m"
systemctl restart nginx
systemctl enable nginx
