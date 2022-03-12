#!bin/bash

# -eq numeric comparision
read -p "Enter a numeric value: " num

numval="[0-9]"
if [ $num -eq  $numval ]; then
  echo -e "\e[33mYou entered a number\e[0m"
else
  echo -e "\e[31You entered a string"
fi