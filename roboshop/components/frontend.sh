#!/bin/bash
Statcheck () {
  if [ $? -eq 0 ]; then
    echo -e "\e[32m- SUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 2
  fi
}

Print() {
  echo -e "\e[36m $1 \e[0m"
}

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo -e "\e[31mYou should be sudo or root user to run this script as\e[0m"
  exit 1
fi

Print "Installing Nginx"
yum install nginx -y
Statcheck

Print "Download nginx content"

curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"
Statcheck


Print "Cleanup Old Nginx Content and Extract new downloaded archive"

cd /usr/share/nginx/html/

rm -rf *
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
Statcheck

Print "Restart Nginx"
systemctl restart nginx
systemctl enable nginx
