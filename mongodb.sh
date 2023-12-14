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
cp mongo.repo  /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "Copying of MongoDB Repo"

dnf install mongodb-org -y  &>> $LOGFILE
VALIDATE $? "Installing of MongoDB"

systemctl enable mongod  &>> $LOGFILE
VALIDATE $? "Enabling MongoDB"

systemctl start mongod &>> $LOGFILE
VALIDATE $? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
VALIDATE $? "Remote access to MongoDB"

systemctl restart mongod &>> $LOGFILE
VALIDATE $? "Restarting MongoDB"

