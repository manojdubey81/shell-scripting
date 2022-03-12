#!bin/bash

# Sting '=' comparision for not equal condition
read -p "Enter your string: " str
if [ "$str" = "ABC" ]; then
  echo -e "\e[32both strings are equal\e[0m"
else
  echo -e "\e[31mboth strings are not equal\e[0m"
fi

