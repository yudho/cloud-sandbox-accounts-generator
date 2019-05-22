#!/bin/bash

echo "How many accounts would you like create vpcs in?"
read number_of_accounts

echo "What account number does it start from? e.g. 1"
read ACCOUNT_START_NUMBER
ACCOUNT_FINISH_NUMBER=$((ACCOUNT_START_NUMBER + number_of_accounts - 1))

echo "What is the account name prefix e.g. myname-workshop"
read account_name_prefix

echo "Are you sure to create default vpcs from account $account_name_prefix$ACCOUNT_START_NUMBER to account $account_name_prefix$ACCOUNT_FINISH_NUMBER? Answer: yes/no"
read confirm

if [ "$confirm" = "no" ]
then
  exit 1
fi

export PROFILE_PREFIX=$account_name_prefix

for i in $(seq $ACCOUNT_START_NUMBER $ACCOUNT_FINISH_NUMBER)
do
  aws ec2 create-default-vpc --profile $PROFILE_PREFIX$i --region us-east-1
  aws ec2 create-default-vpc --profile $PROFILE_PREFIX$i --region ap-southeast-1
  aws ec2 create-default-vpc --profile $PROFILE_PREFIX$i --region ap-southeast-2
  aws ec2 create-default-vpc --profile $PROFILE_PREFIX$i --region ap-northeast-1
  echo "VPC created in region us-east-1, ap-southeast-1, ap-southeast-2, ap-northeast-1"
done

