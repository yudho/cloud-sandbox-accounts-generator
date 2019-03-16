#!/bin/bash

for i in {2..26}
do
  export ACCOUNT_ID=$(aws sts get-caller-identity --profile workshop$i | jq -r '.Account')

  sed -i s/yudho-workshop/yudho-workshop$i/g nuke-config.yml
  sed -i s/000000000000/$ACCOUNT_ID/g nuke-config.yml
  
  printf "yudho-workshop$i\nyudho-workshop$i\n" | ./aws-nuke -c nuke-config.yml --profile workshop$i --no-dry-run
  
  sleep 3m
  
  sed -i s/yudho-workshop$i/yudho-workshop/g nuke-config.yml
  sed -i s/$ACCOUNT_ID/000000000000/g nuke-config.yml
done
