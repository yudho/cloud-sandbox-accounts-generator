#!/bin/bash

export PROFILE_PREFIX=workshop

for i in {2..26}
do 
  echo $(aws sts get-caller-identity --profile $PROFILE_PREFIX$i) | jq -r '.Account'
done
