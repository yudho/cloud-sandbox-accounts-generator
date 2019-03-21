#!/bin/bash

echo "How many accounts would you like to create?"
read number_of_accounts

echo "What number should accounts start from? e.g. 1"
read ACCOUNT_START_NUMBER
ACCOUNT_FINISH_NUMBER=$((ACCOUNT_START_NUMBER + number_of_accounts - 1))

echo "What should be the account name prefix e.g. myname-workshop. NOTE: Make sure it is globally unique"
read ACCOUNT_NAME_PREFIX

echo "What is your email prefix? e.g. john"
read EMAIL_PREFIX

echo "What is your email domain e.g. amazon.com"
read EMAIL_DOMAIN

echo "Are you sure to create accounts from $ACCOUNT_NAME_PREFIX$ACCOUNT_START_NUMBER with email $EMAIL_PREFIX+$ACCOUNT_NAME_PREFIX$ACCOUNT_START_NUMBER@$EMAIL_DOMAIN to $ACCOUNT_NAME_PREFIX$ACCOUNT_FINISH_NUMBER with email $EMAIL_PREFIX+$ACCOUNT_NAME_PREFIX$ACCOUNT_FINISH_NUMBER@$EMAIL_DOMAIN? Answer: yes/no"
read confirm

if [ "$confirm" = "no" ]
then
  exit 1
fi

PROFILE_PREFIX=$ACCOUNT_NAME_PREFIX
TEMPORARY_ACCOUNT_CREATION_IDS_FILE="./account_creation_ids"

touch "$TEMPORARY_ACCOUNT_CREATION_IDS_FILE"
> "$TEMPORARY_ACCOUNT_CREATION_IDS_FILE"

for i in $(seq $ACCOUNT_START_NUMBER $ACCOUNT_FINISH_NUMBER)
do
    CREATE_ACCOUNT_PROCESS_ID=$(aws organizations create-account --email $EMAIL_PREFIX+$ACCOUNT_NAME_PREFIX$i@$EMAIL_DOMAIN --role-name $ACCOUNT_NAME_PREFIX$i --account-name $ACCOUNT_NAME_PREFIX$i | jq -r '.CreateAccountStatus.Id')
    echo $CREATE_ACCOUNT_PROCESS_ID >> "$TEMPORARY_ACCOUNT_CREATION_IDS_FILE"
    echo "Initiated creation of account $ACCOUNT_NAME_PREFIX$i"
    sleep 20s
done

echo "Requests for accounts creation has been done successfully, need to check whether they are done and register to profile. Please wait."
sleep 2m

u=$ACCOUNT_START_NUMBER
SCP_POLICY_ID=$(aws organizations create-policy --type 'SERVICE_CONTROL_POLICY'  --description 'Restrict workshop accounts from using AWS Organizations and from modifying parent account role permissions' --name "$PROFILE_PREFIX-batch-$u-policy" --content "$(cat ./policies/workshop-scp-policy.json)" | jq -r '.Policy.PolicySummary.Id')
while IFS= read -r var
do
  STATUS_RESPONSE=$(aws organizations describe-create-account-status --create-account-request-id "$var")

  while [ "$(echo $STATUS_RESPONSE | jq -r '.CreateAccountStatus.State')" == "IN_PROGRESS" ]
  do
    sleep 10s
  done
  
  if [ "$(echo $STATUS_RESPONSE | jq -r '.CreateAccountStatus.State')" == "SUCCEEDED" ]
  then
    ACCOUNT_ID=$(echo $STATUS_RESPONSE | jq -r ".CreateAccountStatus.AccountId") 
    printf "\n[profile $PROFILE_PREFIX$u]\nrole_arn = arn:aws:iam::$ACCOUNT_ID:role/$ACCOUNT_NAME_PREFIX$u\nsource_profile = default\n" | sudo tee -a ~/.aws/config
    echo "Creation of account $ACCOUNT_NAME_PREFIX$u is successful"
    
    echo "Now creating alias"
    aws iam create-account-alias --account-alias $ACCOUNT_NAME_PREFIX$u --profile $PROFILE_PREFIX$u
    
    echo "Now attaching SCP"
    aws organizations attach-policy --policy-id $SCP_POLICY_ID --target-id $ACCOUNT_ID
    
    echo "Now creating workshop permission boundary"
    sed -i "s/ROLE_ARN_HERE/arn:aws:iam::\*:role\/\*$ACCOUNT_NAME_PREFIX$u\*/g" ./policies/workshop-admin-permission-boundary.json
    ADMIN_BOUNDARY_POLICY_ARN=$(aws iam create-policy --policy-name "AdminBoundaries" --policy-document "$(cat ./policies/workshop-admin-permission-boundary.json)" --profile $PROFILE_PREFIX$u | jq -r '.Policy.Arn')
    sed -i "s/arn:aws:iam::\*:role\/\*$ACCOUNT_NAME_PREFIX$u\*/ROLE_ARN_HERE/g" ./policies/workshop-admin-permission-boundary.json
    
    echo "Now creating workshop permission boundary"
    sed -i "s/ROLE_ARN_HERE/arn:aws:iam::\*:role\/\*$ACCOUNT_NAME_PREFIX$u\*/g" ./policies/workshop-user-permission-boundary.json
    aws iam create-policy --policy-name "WorkshopBoundaries" --policy-document "$(cat ./policies/workshop-user-permission-boundary.json)" --profile $PROFILE_PREFIX$u | jq -r '.Policy.Arn'
    sed -i "s/arn:aws:iam::\*:role\/\*$ACCOUNT_NAME_PREFIX$u\*/ROLE_ARN_HERE/g" ./policies/workshop-user-permission-boundary.json
    
    echo "Now customizing and attaching permission boundary to role"
    aws iam put-role-permissions-boundary --role-name $ACCOUNT_NAME_PREFIX$u --permissions-boundary $ADMIN_BOUNDARY_POLICY_ARN --profile $PROFILE_PREFIX$u
    
    echo "Setup for account $ACCOUNT_NAME_PREFIX$u is done"
  else
    echo "Creation of account $ACCOUNT_NAME_PREFIX$u has failed"
  fi
  u=$((u+1))
done < "$TEMPORARY_ACCOUNT_CREATION_IDS_FILE"