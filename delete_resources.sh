#!/bin/bash
export i=2
#for i in {2..26}
#do
  sed -i s/yudho-workshops2/yudho-workshops2$i/g delete_resources.sh
  aws-nuke -c nuke-config.yml --profile workshop$i
#done
