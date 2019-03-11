#!/bin/bash

for i in {2..26}
do
  aws iam create-account-alias --account-alias yudho-workshop$i  --profile workshop$i
done
