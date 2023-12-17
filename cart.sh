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

curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>> $LOGFILE
VALIDATE $? "Downloading cart application"

cd /app 

unzip -o /tmp/cart.zip &>> $LOGFILE
VALIDATE $? "Unzipping cart"

cd /app

npm install &>> $LOGFILE
VALIDATE $? "Installing dependencies"

cp /home/centos/Roboshop/cart.service  /etc/systemd/system/cart.service &>> $LOGFILE
VALIDATE $? "copying cart service file"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "cart daemon reload"

systemctl enable cart &>> $LOGFILE
VALIDATE $? "Enable cart"

systemctl start cart &>> $LOGFILE
VALIDATE $? "Starting cart"