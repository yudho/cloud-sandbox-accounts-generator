#!/bin/bash

# Change EMAIL_PREFIX, EMAIL_DOMAIN, and ACCOUNT_NAME_PREFIX below accordingly
# For EMAIL_PREFIX, if your email is diponego@amazon.com, you can use diponego+<something>, e.g. diponego+workshop
EMAIL_PREFIX=diponego+workshop
EMAIL_DOMAIN=amazon.com
ACCOUNT_NAME_PREFIX=yudho-workshop

PROFILE_PREFIX=workshop
TEMPORARY_ACCOUNT_CREATION_IDS_FILE="./account_creation_ids"

touch "$TEMPORARY_ACCOUNT_CREATION_IDS_FILE"
> "$TEMPORARY_ACCOUNT_CREATION_IDS_FILE"

u=0
for i in {61..70}
do
    CREATE_ACCOUNT_PROCESS_ID=$(aws organizations create-account --email $EMAIL_PREFIX$i@$EMAIL_DOMAIN --role-name $ACCOUNT_NAME_PREFIX$i --account-name $ACCOUNT_NAME_PREFIX$i | jq -r '.CreateAccountStatus.Id')
    echo $CREATE_ACCOUNT_PROCESS_ID >> "$TEMPORARY_ACCOUNT_CREATION_IDS_FILE"
    echo "Initiated creation of account $ACCOUNT_NAME_PREFIX$i"
    sleep 20s
    u=$((u+1))
done

echo "Requests for accounts creation has been done successfully, need to check whether they are done. Please wait."
sleep 2m

u=$((i-u+1))
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
    echo "Creation of account $u is successful"
  else
    echo "Creation of account $u has failed"
  fi
  u=$((u+1))
done < "$TEMPORARY_ACCOUNT_CREATION_IDS_FILE"