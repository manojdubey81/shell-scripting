#!/bin/bash
#roboshop script
if [ -e "components/$1.sh" ]; then
  echo -e "\e[31m component does not exist\e[0m"
  exit 1
fi

bash "components/$1.sh"