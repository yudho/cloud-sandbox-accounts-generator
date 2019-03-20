#!/bin/bash

# Change this ACCOUNT_NAME_PREFIX accordingly
export ACCOUNT_NAME_PREFIX=yudho-workshop

export PROFILE_PREFIX=workshop

for i in {2..26}
do
  export ACCOUNT_ID=$(aws sts get-caller-identity --profile $PROFILE_PREFIX$i | jq -r '.Account')

  sed -i s/ROLE_NAME_HERE/$ACCOUNT_NAME_PREFIX$i/g nuke-config.yml
  sed -i s/000000000000/$ACCOUNT_ID/g nuke-config.yml
  
  ./aws-nuke -c nuke-config.yml  --no-dry-run --force --profile $PROFILE_PREFIX$i
  
  sleep 3m
  
  sed -i s/$ACCOUNT_NAME_PREFIX$i/ROLE_NAME_HERE/g nuke-config.yml
  sed -i s/$ACCOUNT_ID/000000000000/g nuke-config.yml
done
