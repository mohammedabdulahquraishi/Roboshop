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
echo -e "$R Login with Root user $N" &>> $LOGFILE
exit 1
else 
echo -e "$G Welcome aboard $N" &>> $LOGFILE
fi

VALIDATE() {
    if [ $1 -ne 0 ]
    then
    echo -e "$2 ....$R FAILED $N" &>> $LOGFILE
    exit 1
    else
    echo -e "$2 ....$G SUCCESS $N" &>> $LOGFILE
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

curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>> $LOGFILE
VALIDATE $? "Downloading user application"

cd /app 

unzip -o /tmp/user.zip &>> $LOGFILE
VALIDATE $? "Unzipping user"

cd /app

npm install &>> $LOGFILE
VALIDATE $? "Installing dependencies"

cp /home/centos/Roboshop/user.service  /etc/systemd/system/user.service &>> $LOGFILE
VALIDATE $? "copying user service file"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "user daemon reload"

systemctl enable user &>> $LOGFILE
VALIDATE $? "Enable user"

systemctl start user &>> $LOGFILE
VALIDATE $? "Starting user"

cp /home/centos/Roboshop/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "copying mongodb repo"

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "Installing mongodb client"

mongo --host mongodb.littlesimba.online </app/schema/user.js &>> $LOGFILE

VALIDATE $? "Loading user data into MongoDB" 