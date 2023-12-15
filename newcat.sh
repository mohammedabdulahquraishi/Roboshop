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
echo "Login with Root user"
exit 1
else 
echo "Welcome aboard"
fi

VALIDATE() {
    if [ $1 -ne 0 ]
    then
    echo "$2 ....FAILED"
    exit 1
    else
    echo "$2 ....SUCCESS"
    fi
}


