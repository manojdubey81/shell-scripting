USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
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
  echo -e "\n----------------$1--------------------" &>>${LOG_FILE}
  echo -e "\e[35m $1 \e[0m"
}

LOG_FILE=/tmp/roboshop.log
rm -f ${LOG_FILE}

APP_USER=roboshop

APP_SETUP() {

    Print "Add Deamon user"
    id ${APP_USER}  &>>${LOG_FILE}
    if [ $? -ne 0 ]; then
      Print "Add Application User"
      useradd ${APP_USER} &>>${LOG_FILE}
      StatusChk $? "Useradd"
    fi

    Print "Download ${COMPONENT} archive"
    curl -f -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>"${LOG_FILE}"
    StatusChk $? "${COMPONENT} archive downloaded"

    Print "CleanUp Old Content"
    rm -rf /home/${APP_USER}/${COMPONENT} &>>${LOG_FILE}
    StatusChk $? "CleanUp Old ${COMPONENT}"

    Print "Extract and Load ${COMPONENT} content"
    cd /home/${APP_USER} &>>${LOG_FILE} && unzip -o /tmp/${COMPONENT}.zip &>>${LOG_FILE} && mv ${COMPONENT}-main ${COMPONENT} &>>${LOG_FILE}
    StatusChk $? "Extraction of ${COMPONENT}"

    if [ "$[COMPONENT" = dispatch ]; then
      Print "Build ${COMPONENT} dependencies"
      cd "${COMPONENT} &>>${LOG_FILE} && go mod init "${COMPONENT}" &>>${LOG_FILE} && go get && go build &>>${LOG_FILE}
      StatusChk $? "Build for ${COMPONENT}"
    fi
}

SERVICE_SETUP() {

    Print "Fix App User Permissions"
    chown -R ${APP_USER}:${APP_USER} /home/${APP_USER}
    StatusChk $? "Permissions Setup"

    Print "Setup SystemD file"
    sed -i  -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' \
            -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' \
            -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' \
            -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' \
            -e 's/CARTENDPOINT/cart.roboshop.internal/' \
            -e 's/DBHOST/mysql.roboshop.internal/' \
            -e 's/CARTHOST/cart.roboshop.internal/' \
            -e 's/USERHOST/user.roboshop.internal/' \
            -e 's/AMQPHOST/rabbitmq.roboshop.internal/' \
            /home/${APP_USER}/${COMPONENT}/systemd.service &>>${LOG_FILE} && \
            mv /home/${APP_USER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG_FILE}
    StatusChk $? "${COMPONENT} dependencies Updated"

    Print "Restart ${COMPONENT} Service"
    systemctl daemon-reload &>>${LOG_FILE} && systemctl restart ${COMPONENT} &>>${LOG_FILE} && systemctl enable ${COMPONENT} &>>${LOG_FILE}
    StatusChk $? "${COMPONENT} Service Restart"
}


NodeJS() {

    Print "Configure Yum repos"
    curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>${LOG_FILE}
    StatusChk $? "NodeJS Repo Extraction"

    Print "Install NodeJS"
    yum install nodejs gcc-c++ -y &>>${LOG_FILE}
    StatusChk $? "NodeJS Install"

    APP_SETUP

    Print "Install App Dependencies"
    cd /home/${APP_USER}/${COMPONENT} &>>${LOG_FILE} && npm install &>>${LOG_FILE}
    StatusChk $? "App Dependencies Install"

    SERVICE_SETUP

    echo -e "\n------------${COMPONENT}--------------"
    echo -e "\e[32m ${COMPONENT} Ready to Use\e[0m"
}


MAVIN() {

  Print "Install Maven"
  yum install maven -y &>>${LOG_FILE}
  StatusChk $? "Maven Install"

  APP_SETUP

  Print "Maven Packaging"
  cd /home/${APP_USER}/${COMPONENT} &&  mvn clean package &>>${LOG_FILE} && mv target/shipping-1.0.jar shipping.jar &>>${LOG_FILE}
  StatCheck $? "Maven Packaging Install"

  SERVICE_SETUP

  echo -e "\n------------${COMPONENT}--------------"
  echo -e "\e[32m ${COMPONENT} Ready to Use\e[0m"
}


PYTHON() {

  Print "Install Python"
  yum install python36 gcc python3-devel -y &>>${LOG_FILE}
  StatusChk $? "Python Installation"

  APP_SETUP

  Print "Install Python Dependencies"
  cd /home/${APP_USER}/${COMPONENT} && pip3 install -r requirements.txt &>>${LOG_FILE}
  StatusChk $? "Python Dependencies Install"

  SERVICE_SETUP

  echo -e "\n------------${COMPONENT}--------------"
  echo -e "\e[32m ${COMPONENT} Ready to Use\e[0m"
}


GOLANG()  {

  Print "Install GoLang"
  yum install golang -y &>>${LOG_FILE}
  StatusChk $? "GoLang Installation"

  APP_SETUP

  SERVICE_SETUP

  echo -e "\n------------${COMPONENT}--------------"
  echo -e "\e[32m ${COMPONENT} Ready to Use\e[0m"
}