#!/bin/bash

source components/common.sh

Print "Configure Yum repos"
curl -f -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash - &>>${LOG_FILE}
StatusChk $? "RebbitMQ Repo Extraction"


Print "Install ErLang & RabbitMQ"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y &>>${LOG_FILE}
StatusChk $? "Erlang and RebbitMQ Install"


Print "Start RebbitMQ Service"
systemctl restart rabbitmq-server &>>${LOG_FILE} && systemctl enable rabbitmq-server &>>${LOG_FILE}
StatusChk $? "RebbitMQ Service Restart"

rabbitmqctl list_users | grep roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  Print "Create Application User"
  rabbitmqctl add_user roboshop roboshop123 &>>${LOG_FILE}
  StatusChk $? "Application user creation"
fi

Print "Configure Application User"
rabbitmqctl set_user_tags roboshop administrator &>>${LOG_FILE} && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG_FILE}
StatusChk $? "Application User Configuration"

Readymsg



