#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing at $TIMESTAMP" &>> $LOGFILE

if [ $ID -ne 0 ]
then
echo -e "$R YOU ARE NOT A ROOT USER.ACCESS DENIED $N" &>> $LOGFILE
exit 1
else 
echo -e "$G WELCOME ABOARD $N" &>> $LOGFILE
fi

VALIDATE() {
    if [ $1 -ne 0 ]
    then
    echo -e "$2 ....$R FAILED $N" 
    exit 1
    else
    echo -e "$2 ....$G SUCCESS $N" 
    fi
}

dnf module disable mysql -y &>> $LOGFILE
VALIDATE $? "Disabling of older version of mysql"

cp /home/centos/Roboshop/mysql.repo /etc/yum.repos.d/mysql.repo &>> $LOGFILE
VALIDATE $? "copying mysql repo"

dnf install mysql-community-server -y &>> $LOGFILE
VALIDATE $? "Installing mysql server"

systemctl enable mysqld &>> $LOGFILE
VALIDATE $? "Enabling mysql"

systemctl start mysqld &>> $LOGFILE
VALIDATE $? "Starting mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>> $LOGFILE
VALIDATE $? "Changing default password of mysql"

mysql -uroot -pRoboShop@1 &>> $LOGFILE
VALIDATE $? "check new password of mysql"