#!/bin/bash

export PROFILE_PREFIX=workshop

for i in {61..70}
do
  echo $PROFILE_PREFIX$i 
  aws iam list-users --profile $PROFILE_PREFIX$i
done
