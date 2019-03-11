#!/bin/bash

for i in {2..26}
do
  export ACCOUNT_ID=$(aws sts get-caller-identity --profile workshop$i | jq -r ".Account")
  export AIML_POLICY_ARN=$(aws iam list-policies --only-attached  --scope Local --profile workshop$i |  jq -r ".Policies[].Arn")
  aws iam delete-login-profile --user-name workshop-user --profile workshop$i
  aws iam detach-user-policy --user-name workshop-user --policy-arn $AIML_POLICY_ARN --profile workshop$i
  aws iam delete-user --user-name workshop-user --profile workshop$i
  aws iam detach-role-policy --role-name "SagemakerNotebookInstanceRole" --policy-arn $AIML_POLICY_ARN --profile workshop$i
  aws iam delete-role --role-name "SagemakerNotebookInstanceRole" --profile workshop$i
  aws iam detach-role-policy --role-name "PersonalizeRole" --policy-arn "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess" --profile workshop$i 
  aws iam delete-role --role-name "PersonalizeRole" --profile workshop$i
  aws iam delete-policy --policy-arn "arn:aws:iam::$ACCOUNT_ID:policy/aiml-workshop-policy" --profile workshop$i
done
