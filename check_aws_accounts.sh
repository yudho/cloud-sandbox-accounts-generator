#!/bin/bash

export PROFILE_PREFIX=workshop

for i in {2..26}
do
  echo workshop$i 
  aws iam list-users --profile $PROFILE_PREFIX$i
done
