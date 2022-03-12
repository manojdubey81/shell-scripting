Statcheck () {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32m- SUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
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