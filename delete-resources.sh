#!/bin/bash

echo "How many accounts would you like to delete resources in?"
read number_of_accounts

echo "What account number does it start from? e.g. 1"
read ACCOUNT_START_NUMBER
ACCOUNT_FINISH_NUMBER=$((ACCOUNT_START_NUMBER + number_of_accounts - 1))

echo "What is the account name prefix e.g. myname-workshop"
read ACCOUNT_NAME_PREFIX

echo "Are you sure to delete all resources (except resources to switch role as admin) in all account/s from account $ACCOUNT_NAME_PREFIX$ACCOUNT_START_NUMBER to account $ACCOUNT_NAME_PREFIX$ACCOUNT_FINISH_NUMBER? Answer: yes/no"
read confirm

if [ "$confirm" = "no" ]
then
  exit 1
fi

export PROFILE_PREFIX=$ACCOUNT_NAME_PREFIX

for i in $(seq $ACCOUNT_START_NUMBER $ACCOUNT_FINISH_NUMBER)
do
  ACCOUNT_ID=$(aws sts get-caller-identity --profile $PROFILE_PREFIX$i | jq -r '.Account')

  sed -i s/000000000000/$ACCOUNT_ID/g nuke-config.yml
  
  aws-nuke -c nuke-config.yml  --no-dry-run --force --profile $PROFILE_PREFIX$i
  
  sleep 5s
  
  sed -i s/$ACCOUNT_ID/000000000000/g nuke-config.yml
  echo "Finished deleting resources for account $ACCOUNT_NAME_PREFIX$i"
done
