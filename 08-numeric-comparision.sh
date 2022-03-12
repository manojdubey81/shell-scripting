#!bin/bash

# -eq numeric comparision
read -p "Type your input: " num

#numval=[0 1 2 3 4 5 6 7 8 9]

if [ "$num" -eq  100 ]; then
  echo -e "\e[33mYou entered a number\e[0m"
else
  echo -e "\e[31mYou entered a string\e[0m"
fi