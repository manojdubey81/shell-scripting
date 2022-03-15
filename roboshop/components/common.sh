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

App_User=roboshop


NodeJS() {
  Print "Download NodeJS Repo"
  curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>${LOG_FILE}
  Statuschk $? "NodeJS Download-"

  Print "Install NodeJS"
  yum install nodejs gcc-c++ -y &>>{LOG_FILE}
  Statuschk $? "NodeJS Install-"

  Print "Add User $APP_USER"
  id ${APP_USER} &>>${LOG_FILE}
  if [ $? -ne 0] ; then
    useradd ${APP_USER} &>>${LOG_FILE}
    Statuschk $? "User $APP_USER Added-"
  fi

  Print "Download $COMPONENT Repo"
  curl -f -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG_FILE}
  Statuschk &? "$COMPONENT repo downloaded-"

  Print "CleanUp Old Content"
  rm -rf /home/${APP_USER}/${COMPONENT} &>>${LOG_FILE}
  StatCheck $? "Old Cleanup-"

  Print "Extract $COMPONENT"
  cd /home/${APP_USER} &>>${LOG_FILE} && unzip -o /tmp/${COMPONENT}.zip &>>${LOG_FILE} && mv ${COMPONENT}-main $COMPONENT &>>${LOG_FILE}
  Statuschk &? "$COMPONENT Extracted-"

  Print "Install npm"
  cd /home/${APP_USER}/${COMPONENT} &>>${LOG_FILE} && npm install &>>${LOG_FILE}
  Statuschk &? "npm Installed-"

  Print "Setup SystemD File"
  sed -i -e 's/MONGO_DNSNAME/mongodb.${APP_USER}.internal/' \
         -e 's/REDIS_ENDPOINT/redis.${APP_USER}.internal/'  \
         -e 's/MONGO_ENDPOINT/mongodb.${APP_USER}.internal/' \
         -e 's/CATALOGUE_ENDPOINT/catalogue.${APP_USER}.internal/' \
         /home/${APP_USER}/${COMPONENT}/systemd.service &>>${LOG_FILE}
         && mv /home/${APP_USER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service  &>>${LOG_FILE}
  StatCheck $? "SystemD File Updated-"

  Print "Restart ${COMPONENT} Service"
  systemctl daemon-reload &>>${LOG_FILE} && systemctl restart catalogue &>>${LOG_FILE} && systemctl enable catalogue &>>${LOG_FILE}
  Statuschk $? "${COMPONENT} Service Restarted-"
}