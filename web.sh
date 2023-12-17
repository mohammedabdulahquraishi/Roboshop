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

    dnf install nginx -y &>> $LOGFILE
    VALIDATE $? "Installing Nginx"

    systemctl enable nginx &>> $LOGFILE
    VALIDATE $? "Enabling Nginx"

    systemctl start nginx &>> $LOGFILE
    VALIDATE $? "Starting Nginx"

    rm -rf /usr/share/nginx/html/* &>> $LOGFILE
    VALIDATE $? "Removing default nginx content"

    curl -L -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>> $LOGFILE
    VALIDATE $? "Downloading the frontend content"

    cd /usr/share/nginx/html &>> $LOGFILE
    VALIDATE $? "CD to html"

    unzip -o /tmp/web.zip &>> $LOGFILE
    VALIDATE $? "Unzipping frontend content"

    cp /home/centos/Roboshop/roboshop.conf /etc/nginx/default.d/roboshop.conf &>> $LOGFILE
    VALIDATE $? "creating Ip addresses of server"

    systemctl restart nginx $LOGFILE
    VALIDATE $? "Restarting Nginx"



