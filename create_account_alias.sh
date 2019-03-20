#!/bin/bash

# Change ACCOUNT_NAME_PREFIX below accordingly
export ACCOUNT_NAME_PREFIX=yudho-workshop

export PROFILE_PREFIX=workshop

for i in {27..51}
do
  aws iam create-account-alias --account-alias $ACCOUNT_NAME_PREFIX$i  --profile $PROFILE_PREFIX$i
done
