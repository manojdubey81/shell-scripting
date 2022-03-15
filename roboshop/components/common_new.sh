USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo -e "\e[31mYou should be sudo or root user to run this script\e[0m"
  exit 1
fi

StatusChk () {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32m$2-SUCCESS\e[0m"
  else
    echo -e "\e[31m$2-FAILURE\e[0m"
    exit 2
  fi
}

Print() {
  echo -e "\n----------------$1--------------------"
  echo -e "\e[35m $1 \e[0m"
}

LOG_FILE=/tmp/roboshop.log
rm -f ${LOG_FILE}