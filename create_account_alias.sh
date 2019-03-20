#!/bin/bash

# Change ACCOUNT_NAME_PREFIX below accordingly
ACCOUNT_NAME_PREFIX=yudho-workshop

PROFILE_PREFIX=workshop

for i in {61..70}
do
  aws iam create-account-alias --account-alias $ACCOUNT_NAME_PREFIX$i  --profile $PROFILE_PREFIX$i
done
