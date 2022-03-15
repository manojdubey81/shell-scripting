#!/bin/bash

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