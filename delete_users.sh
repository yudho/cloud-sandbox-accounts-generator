#!/bin/bash

for i in {2..26}
do
  export ACCOUNT_ID=$(aws sts get-caller-identity --profile workshop$i | jq -r ".Account")
  aws iam delete-login-profile --user-name workshop-user --profile workshop$i
  aws iam detach-user-policy --user-name workshop-user --policy-arn "arn:aws:iam::$ACCOUNT_ID:policy/workshop-user-policy" --profile workshop$i
  aws iam delete-user --user-name workshop-user --profile workshop$i
  aws iam delete-policy --policy-arn "arn:aws:iam::$ACCOUNT_ID:policy/workshop-user-policy" --profile workshop$i
done
