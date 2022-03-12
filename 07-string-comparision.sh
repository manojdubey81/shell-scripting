#!bin/bash

# Sting '=' comparision
read -p "Enter your string: " str

if [ "$str" = "ABC" ]; then
  echo -e "\e[32min '=' comparision strings are equal\e[0m"
else
  echo -e "\e[31min '=' comparision both strings are not equal\e[0m"
fi



#string '==' comparision

if [ "str" == "ABC" ]; then
  echo -e "\e[33min '==' comparision both string are not equal\e[0m"
else
  echo -e "\e[34min '==' comparision both string are equal\e[0m"
fi

#string '-z' test

if [ ! -z $str ]; then
  echo -e "\e[36minput string holds some value\e[0m"
else
  echo -e "\e[35minput string does not hold any value\e[0m"
fi
