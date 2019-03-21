#!/bin/bash

echo "How many accounts would you like create users in?"
read number_of_accounts

echo "What account number does it start from? e.g. 1"
read ACCOUNT_START_NUMBER
ACCOUNT_FINISH_NUMBER=$((ACCOUNT_START_NUMBER + number_of_accounts - 1))

echo "What is the account name prefix e.g. myname-workshop"
read account_name_prefix

echo "What should be the user name e.g. workshop-user"
read USER_NAME

echo "What is the user password?"
read USER_PASSWORD

echo "Are you sure to create user $USER_NAME with password specified in all account/s from account $account_name_prefix$ACCOUNT_START_NUMBER to account $account_name_prefix$ACCOUNT_FINISH_NUMBER? Answer: yes/no"
read confirm

if [ "$confirm" = "no" ]
then
  exit 1
fi

export PROFILE_PREFIX=$account_name_prefix

for i in $(seq $ACCOUNT_START_NUMBER $ACCOUNT_FINISH_NUMBER)
do
  ACCOUNT_ID=$(aws sts get-caller-identity --profile $PROFILE_PREFIX$i | jq -r ".Account")
  WORKSHOP_USER_POLICY_ARN=$(aws iam create-policy --policy-name workshop-user-policy --policy-document "$(cat ./policies/workshop-user-policy.json)" --profile $PROFILE_PREFIX$i | jq -r ".Policy.Arn")
  aws iam create-user --user-name $USER_NAME --profile $PROFILE_PREFIX$i
  aws iam put-user-permissions-boundary --user-name $USER_NAME --permissions-boundary "arn:aws:iam::$ACCOUNT_ID:policy/WorkshopBoundaries" --profile $PROFILE_PREFIX$i
  aws iam attach-user-policy --user-name $USER_NAME --policy-arn $WORKSHOP_USER_POLICY_ARN --profile $PROFILE_PREFIX$i
  aws iam create-login-profile --user-name $USER_NAME --password $USER_PASSWORD --password-reset-required --profile $PROFILE_PREFIX$i
  echo "User created"
done
