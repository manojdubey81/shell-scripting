#!/bin/bash

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 &>>${LOG_FILE}]; then
  echo -e "\e[31mYou should be sudo or root user to run this script as\e[0m"
  exit 1
fi

StatusChk() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32$2-Success\e[0m"
  else
    echo -e "\e[31$2-Failure\e[0m"
  fi
}

Print() {
  echo "\n------------------$1-----------------------"
  echo -e "\e[35m $1 \e[0m"
}

LOG_FILE=/tmp/roboshop.log