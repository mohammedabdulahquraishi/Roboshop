#!/bin/bash
AMI_ID=ami-03265a0778a880afb
SG_ID=sg-07062d9c12192a838
INSTANCES=("MONGODB") # "CART" "CATALOGUE" "MYSQL" "PAYMENT" "RABBITMQ" "REDIS" "SHIPPING" "USER" "WEB")

for i in  "${INSTANCES[@]}"
do
    echo "Instance is: $i"
    if [ $i == "MONGODB" ] || [ $i == "MYSQL" ] || [ $i == "SHIPPING" ]
    then 
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    aws ec2 run-instances --image-id ami-03265a0778a880afb --count 1 --instance-type $INSTANCE_TYPE --key-name sg-07062d9c12192a838

 
done     