USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo -e "\e[31mYou should be sudo or root user to run this script\e[0m"
  exit 1
fi

StatusChk () {
  if [ "$1" -eq 0 ]; then
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

APP_USER=roboshop

NodeJS() {
  Print "Configure Yum repos"
    curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>"${LOG_FILE}"
  StatusChk $? "NodeJS Repo Extraction"

  Print "Install NodeJS"
    yum install nodejs gcc-c++ -y &>>"${LOG_FILE}"
  StatusChk $? "NodeJS Install"

  Print "Add Deamon user"
  id "${APP_USER}"  &>>"${LOG_FILE}"
  if [ "$?" -ne 0 ]; then
    Print "Add Application User"
    useradd "${APP_USER}" &>>"${LOG_FILE}"
    StatusChk $? "Deamon Useradd"
  fi

  Print "Download ${COMPONENT} archive"
  curl -f -s -L -o /tmp/"${COMPONENT}".zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>"${LOG_FILE}"
  StatusChk $? "${COMPONENT} archive downloaded"

  Print "Extract and Load ${COMPONENT} repo"
  cd /home/"${APP_USER}" && unzip -o /tmp/"${COMPONENT}".zip &>>"${LOG_FILE}" && mv "${COMPONENT}"-main "${COMPONENT}" &>>"${LOG_FILE}"
  StatusChk $? "Extraction of ${COMPONENT}"

  Print "npm Install"
  cd /home/"${APP_USER}"/"${COMPONENT}" && npm install &>>"${LOG_FILE}"
  StatusChk $? "npm Install"

  Print "Update mongodb private IP in SystemD file"
  mv /home/"${APP_USER}"/"${COMPONENT}"/systemd.service /etc/systemd/system/"${COMPONENT}".service &>>"${LOG_FILE}"
  StatusChk $? "systemd file moved to default location"

  sed -i -e '/MONGO_DNSNAME/"${MONGODB_IP}"/' /etc/systemd/system/"${COMPONENT}".service &>>"${LOG_FILE}"
  StatusChk $? "MONGO_DNSNAME Updated"

  Print "Restart deamon"
  systemctl daemon-reload &>>"${LOG_FILE}" && systemctl restart "${COMPONENT}" &>>"${LOG_FILE}" && systemctl enable "${COMPONENT}" &>>"${LOG_FILE}"

  echo -e "\e[32m ${COMPONENT} Ready to Use\e[0m"
}