#!bin/bash

# -eq numeric comparision
read -p "Type your input: " num

numval='^[0-9]+$'
if [ $num -ne  $numval ]; then
  echo -e "\e[33mYou entered a number\e[0m"
else
  echo -e "\e[31mYou entered a string"
fi