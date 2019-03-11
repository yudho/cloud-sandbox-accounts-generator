#!/bin/bash
for i in {2..26}
do
  echo workshop$i 
  aws iam list-users --profile workshop$i
done
