This program is to manage AWS accounts used for workshops attendees.
The program involves creating AWS accounts, creating users, deleting users, and deleting resources 

-----------------------------
PREREQUISITES
-----------------------------
1. Install jq
2. Install aws-nuke from https://github.com/rebuy-de/aws-nuke or download its binary

-----------------------------
GUIDES
-----------------------------
CREATING ACCOUNTS AND USERS
1. Run create-aws-accounts.sh to create AWS accounts
2. Run create-users.sh to create IAM users
3. Run check-aws-accounts.sh to check whether accounts and users were created, and to list IAM users.

DELETING USERS AND RESOURCES
1. Run delete-users.sh
2. Check nuke-config.yml, make sure the account to be deleted is resetted to 
      "000000000000": {}
   and run delete-resources.sh
   NOTE: This will delete DEFAULT VPCS, SUBNETS, and associated resources.

PREPARING FOR ANOTHER WORKSHOP
1. Run create-users.sh, since the accounts are already created and never deleted.
2. Run create-default-vpcs.sh to re-create default VPCs. It will create VPC in 4 regions (us-east-1, ap-southeast-1, ap-southeast-2, and ap-northeast-1. You can easily modify the script to add more regions or change regions to be covered.

LIST ACCOUNT IDS
1. Run get-account-ids.sh

-----------------------------
NOTES
-----------------------------
1. If you use Cloud9, you need to disable its temporary credentials feature, and user accessKey + secretKey for an IAM user instead
