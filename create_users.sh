#!/bin/bash

# Do not forget to set AWS_USER_PASSWORD environment variable value
# Change this USER_NAME variable as necessary
USER_NAME=workshop-user

PROFILE_PREFIX=workshop

for i in {61..70}
do
  WORKSHOP_USER_POLICY_ARN=$(aws iam create-policy --policy-name workshop-user-policy --policy-document "$(cat ./policies/workshop-user-policy.json)" --profile $PROFILE_PREFIX$i | jq -r ".Policy.Arn")
  aws iam create-user --user-name $USER_NAME --profile $PROFILE_PREFIX$i
  aws iam attach-user-policy --user-name $USER_NAME --policy-arn $WORKSHOP_USER_POLICY_ARN --profile $PROFILE_PREFIX$i
  aws iam create-login-profile --user-name $USER_NAME --password $AWS_USER_PASSWORD --password-reset-required --profile $PROFILE_PREFIX$i
done
