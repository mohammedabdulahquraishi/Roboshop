#!/bin/bash
AMI_ID=ami-03265a0778a880afb
SG_ID=sg-07062d9c12192a838
INSTANCES=("MONGODB" "CART" "CATALOGUE" "MYSQL" "PAYMENT" "RABBITMQ" "REDIS" "SHIPPING" "USER" "WEB")
ZONE_ID=Z02773932U4NB4GX343HA
DOMAIN_NAME=littlesimba.online

for i in  "${INSTANCES[@]}"
do
    echo "Instance is: $i"
    if [ $i == "MONGODB" ] || [ $i == "MYSQL" ] || [ $i == "SHIPPING" ]
    then 
        INSTANCE_TYPE="t3.small"
    else
        INSTANCE_TYPE="t2.micro"
    fi

    IP_ADDRESS=$(aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type $INSTANCE_TYPE --security-group-ids sg-07062d9c12192a838 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)

    echo "$i: $IP_ADDRESS"

    aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
    {
        "Comment": "Creating a record set for cognito endpoint"
        ,"Changes": [{
        "Action"              : "CREATE"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$i'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP_ADDRESS'"
            }]
        }
        }]
    }
    '
done   
