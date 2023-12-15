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

id roboshop
if [ $? -ne 0 ]
then 
    useradd roboshop &>> $LOGFILE
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir -p /app &>> $LOGFILE
VALIDATE $? "creating app directory"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE
VALIDATE $? "Downloading catalogue application"

cd /app 

unzip /tmp/catalogue.zip &>> $LOGFILE
VALIDATE $? "Unzipping catalogue"

cd /app

npm install &>> $LOGFILE
VALIDATE $? "Installing dependencies"

cp /home/centos/Roboshop/catalogue.service  /etc/systemd/system/catalogue.service &>> $LOGFILE
VALIDATE $? "copying catalogue service file"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "catalogue daemon reload"

systemctl enable catalogue &>> $LOGFILE
VALIDATE $? "Enable catalogue"

systemctl start catalogue &>> $LOGFILE
VALIDATE $? "Starting catalogue"

cp /home/centos/Roboshop/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying mongodb repo"

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "Installing mongodb client"

mongo --host mongodb.littlesimba.online </app/schema/catalogue.js &>> $LOGFILE

VALIDATE $? "Loading catalouge data into MongoDB" 
