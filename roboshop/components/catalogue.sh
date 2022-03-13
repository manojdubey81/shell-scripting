#!bin/bash

Source components/common.sh

Print "Download NodeJS Repo"

curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
Statuschk $?

Print "Install NodeJS"

yum install nodejs gcc-c++ -y
Statuschk $?

Print "Add User roboshop"
useradd roboshop
Statuschk $?

1. So let's switch to the `roboshop` user and run the following commands.

```bash
$ curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip"
$ cd /home/roboshop
$ unzip /tmp/catalogue.zip
$ mv catalogue-main catalogue
$ cd /home/roboshop/catalogue
$ npm install

```

1. Update SystemD file with correct IP addresses
    
    Update `MONGO_DNSNAME` with MongoDB Server IP
    
2. Now, lets set up the service with systemctl.

```bash
# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue

```