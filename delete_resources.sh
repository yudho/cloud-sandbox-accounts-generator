#!/bin/bash
i = 2
#for i in {2..26}
#do
  sed -i s/yudho-workshops/yudho-workshops$i/g delete_resources.sh
  aws-nuke -c nuke-config.yml --profile workshop$i
#done
