#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-07062d9c12192a838
ZONE_ID=Z02773932U4NB4GX343HA
INSTANCE=("mongodb" "user" "web" "cart")

for i in "{$INSTANCE[@]}"
do
    if {$INSTANCE[$i] == "mongodb"}
    then
    INSTANCE_TYPE="t3.small"
    else
    INSTANCE_TYPE="t2.micro"
    fi
aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-07062d9c12192a838
done