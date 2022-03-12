#!bin/bash

a=(10 20 30 manoj "I am ok")

echo -e "\e[32m Arrays First element is : \e[0m" ${a[0]}
echo -e "\n \e[32m Arrays Second element is : \e[0m" ${a[1]}
echo -e "\n \e[32m Arrays Third element is : \e[0m" ${a[2]}
echo -e "\n \e[32m Arrays all element is : \e[0m" $a