#!/bin/bash

for i in {2..26}
do
  export WORKSHOP_USER_POLICY_ARN=$(aws iam create-policy --policy-name workshop-user-policy --policy-document "$(cat ./policies/workshop-user-policy.json)" --profile workshop$i | jq -r ".Policy.Arn")
  echo $WORKSHOP_USER_POLICY_ARN
  aws iam create-user --user-name workshop-user --profile workshop$i
  aws iam attach-user-policy --user-name workshop-user --policy-arn $WORKSHOP_USER_POLICY_ARN --profile workshop$i
  aws iam create-login-profile --user-name workshop-user --password merahputih --password-reset-required --profile workshop$i
done 
