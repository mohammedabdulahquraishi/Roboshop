#! /bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

ID=$(id -u)

if [ $ID -ne 0 ]
then
echo -e "You are $R NOT A ROOT USER" &>> $LOGFILE
exit 99
else
echo "You are allowed to access"
fi

VALIDATE () {
    if [ $1 -ne 0 ]
    then
    echo -e "$2 ....$R FAILED $N"
    exit 99
    else 
    echo -e "$2 ....$G SUCCESS $N"
    fi
}

dnf install maven -y &>> $LOGFILE
VALIDATE $? "Installing maven"


id roboshop #if roboshop user does not exist, then it is failure
if [ $? -ne 0 ]
then
    useradd roboshop
    VALIDATE $? "roboshop user creation"
else
    echo -e "roboshop user already exist $Y SKIPPING $N"
fi

mkdir -p /app &>> $LOGFILE
VALIDATE $? "creating app directory"

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>> $LOGFILE
VALIDATE $? "Downloading catalogue application"

cd /app 

unzip /tmp/shipping.zip &>> $LOGFILE
VALIDATE $? "Unzipping shipping"

cd /app

mvn clean package &>> $LOGFILE
VALIDATE $? "Installing dependencies"

mv target/shipping-1.0.jar shipping.jar &>> $LOGFILE
VALIDATE $? "renaming jar file"

cp /home/centos/Roboshop/shipping.service /etc/systemd/system/shipping.service &>> $LOGFILE
VALIDATE $? "copying shipping service"

systemctl daemon-reload &>> $LOGFILE
VALIDATE $? "deamon reload"

systemctl enable shipping  &>> $LOGFILE
VALIDATE $? "enable shipping"

systemctl start shipping &>> $LOGFILE
VALIDATE $? "start shipping"

dnf install mysql -y &>> $LOGFILE
VALIDATE $? "install MySQL client"

mysql -h mysql.littlesimba.online -uroot -pRoboShop@1 < /app/schema/shipping.sql &>> $LOGFILE
VALIDATE $? "loading shipping data"

systemctl restart shipping &>> $LOGFILE
VALIDATE $? "restart shipping"
