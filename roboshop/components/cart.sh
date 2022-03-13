#!bin/bash

Source components/common.sh

Print "Download NodeJS Repo"

curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
Statuschk $? "NodeJS archive Download"

Print "Install NodeJS"

yum install nodejs gcc-c++ -y
Statuschk $? "NodeJS installation"

Print "Add User roboshop"
useradd roboshop
Statuschk $? "useradd"

1. So let's switch to the `roboshop` user and run the following commands.

```bash
$ curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"
$ cd /home/roboshop
$ unzip /tmp/cart.zip
$ mv cart-main cart
$ cd /home/roboshop/cart
$ npm install

```

Update `REDIS_ENDPOINT` with REDIS server IP Address
      Update `CATALOGUE_ENDPOINT` with Catalogue server IP address

2. Now, lets set up the service with systemctl.

```bash
# mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue

```