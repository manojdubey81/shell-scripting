#!/bin/bash

a=100
b=200

echo -e "\e[32m First Value is $a\e[0m"
echo -e "\e[33m Second Value is $b\e[0m"

ADD = $(($a + $b))

echo add = $ADD

