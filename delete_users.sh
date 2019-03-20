#!/bin/bash

# Change this USER_NAME variable as necessary
USER_NAME=workshop-user

PROFILE_PREFIX=workshop

for i in {61..70}
do
  ACCOUNT_ID=$(aws sts get-caller-identity --profile $PROFILE_PREFIX$i | jq -r ".Account")
  echo $ACCOUNT_ID
  aws iam detach-user-policy --user-name $USER_NAME --policy-arn "arn:aws:iam::$ACCOUNT_ID:policy/workshop-user-policy" --profile $PROFILE_PREFIX$i
  aws iam delete-login-profile --user-name $USER_NAME --profile $PROFILE_PREFIX$i
  aws iam delete-user --user-name $USER_NAME --profile $PROFILE_PREFIX$i
  aws iam delete-policy --policy-arn "arn:aws:iam::$ACCOUNT_ID:policy/workshop-user-policy" --profile $PROFILE_PREFIX$i
done
