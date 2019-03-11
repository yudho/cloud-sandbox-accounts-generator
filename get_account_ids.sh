#!/bin/bash
for i in {2..26}
do 
  echo $(aws sts get-caller-identity --profile workshop$i) | jq -r '.Account'
done
