#! /bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script started executing on $TIMESTAMP" &>> $LOGFILE

if [ $ID -ne 0 ]
then
echo -e "$R ERROR::You are not a root user $N" &>> $LOGFILE
exit 1
else
echo -e "$G Welcome aboard $N" &>> $LOGFILE
fi

VALIDATE() {
    if [ $1 -ne 0 ]
    then
    echo -e "$2 .... $R FAILED" &>> $LOGFILE
    exit 1
    else
    echo -e "$2 .... $G SUCCESS" &>> $LOGFILE
    fi
}

dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> $LOGFILE
VALIDATE $? "Installing Redis Repo"

dnf module enable redis:remi-6.2 -y &>> $LOGFILE
VALIDATE $? "Enabling Redis Repo"

dnf install redis -y &>> $LOGFILE
VALIDATE $? "Installing Redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>> $LOGFILE
VALIDATE $? "Updating IP to 0.0.0.0"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf &>> $LOGFILE
VALIDATE $? "Updating IP to 0.0.0.0"

systemctl enable redis &>> $LOGFILE
VALIDATE $? "Enabling Redis"

systemctl start redis &>> $LOGFILE
VALIDATE $? "Starting Redis"