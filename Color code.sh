#!bin/bash

echo Hello World

## Color Codes : Red-> 31, Green-> 32, Yellow-> 33, Blue-> 34, Megenta-> 35, Cyan-> 36
# Syntax : echo -e "\e[31mHello\[0m"
# -e is option to enable escape seq, without -e colors/tab/new line will not work
# "" Quotes are mandatory for colors to work, otherwise it will not work.
# Optionally we can use single quote, but preferred to use double quote.
# \e[COLm -> this is to enable color, COL here is one of the above color codes.
# \[0m -> to disable color code

echo "\e[31m Hellow World \[0m"
echo "\e[32m Hellow World \[0m"
echo "\e[33m Hellow World \[0m"
echo "\e[34m Hellow World \[0m"
echo "\e[35m Hellow World \[0m"
