#!bin/bash

# Sting '=' comparision
read -p "Enter your string: " str
if [ "$str" = "ABC" ]; then
  echo -e "\e[32mboth strings are equal\e[0m"
else
  echo -e "\e[31mboth strings are not equal\e[0m"
fi



#string '==' comparision

if [ "str" == "ABC"]; then
  echo -e "\e[33mboth string are not equal\e[0m"
else
  echo -e "\e[34mboth string are equal\e[0m"
fi
