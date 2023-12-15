#! /bin/bash

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
echo -e "$R Login with Root user $N"
exit 1
else 
echo -e "$G Welcome aboard $N"
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

dnf module disable nodejs -y  &>> $LOGFILE
VALIDATE $? "Disabling of older version of Nodejs" 

dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "Enabling of version 18 of Nodejs"

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "Installing of version 18 of Nodejs"
