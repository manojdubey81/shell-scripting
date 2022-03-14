Statcheck () {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32m$2 SUCCESS\e[0m"
  else
    echo -e "$2 \e[31m$2 FAILURE\e[0m"
    exit 2
  fi
}

Print() {
  echo -e "\e[36m $1 \e[0m"
}

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo -e "\e[31mYou should be sudo or root user to run this script as\e[0m"
  exit 1
fi

LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE
