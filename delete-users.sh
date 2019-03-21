#!/bin/bash

echo "How many accounts would you like delete users in?"
read number_of_accounts

echo "What account number does it start from? e.g. 1"
read ACCOUNT_START_NUMBER
ACCOUNT_FINISH_NUMBER=$((ACCOUNT_START_NUMBER + number_of_accounts - 1))

echo "What is the account name prefix e.g. myname-workshop"
read account_name_prefix

echo "What is the user name to delete"
read USER_NAME

echo "Are you sure to delete user $USER_NAME with password specified in all account/s from account $account_name_prefix$ACCOUNT_START_NUMBER to account $account_name_prefix$ACCOUNT_FINISH_NUMBER? Answer: yes/no"
read confirm

if [ "$confirm" = "no" ]
then
  exit 1
fi

export PROFILE_PREFIX=$account_name_prefix

for i in $(seq $ACCOUNT_START_NUMBER $ACCOUNT_FINISH_NUMBER)
do
  ACCOUNT_ID=$(aws sts get-caller-identity --profile $PROFILE_PREFIX$i | jq -r ".Account")
  aws iam detach-user-policy --user-name $USER_NAME --policy-arn "arn:aws:iam::$ACCOUNT_ID:policy/workshop-user-policy" --profile $PROFILE_PREFIX$i
  aws iam delete-login-profile --user-name $USER_NAME --profile $PROFILE_PREFIX$i
  aws iam delete-user --user-name $USER_NAME --profile $PROFILE_PREFIX$i
  aws iam delete-policy --policy-arn "arn:aws:iam::$ACCOUNT_ID:policy/workshop-user-policy" --profile $PROFILE_PREFIX$i
  echo "Deleted"
done
