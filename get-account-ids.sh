#!/bin/bash

echo "How many accounts would you like to get the IDs?"
read number_of_accounts

echo "What account number does it start from? e.g. 1"
read ACCOUNT_START_NUMBER
ACCOUNT_FINISH_NUMBER=$((ACCOUNT_START_NUMBER + number_of_accounts - 1))

echo "What is the account name prefix e.g. myname-workshop"
read account_name_prefix

export PROFILE_PREFIX=$account_name_prefix

for i in $(seq $ACCOUNT_START_NUMBER $ACCOUNT_FINISH_NUMBER)
do 
  echo $(aws sts get-caller-identity --profile $PROFILE_PREFIX$i) | jq -r '.Account'
done
