#!/bin/bash

AMI=ami-03265a0778a880afb
SG_ID=sg-07062d9c12192a838


aws ec2 run-instances --image-id ami-03265a0778a880afb --instance-type t2.micro --security-group-ids sg-07062d9c12192a838
