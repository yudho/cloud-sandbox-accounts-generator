This program is to manage AWS accounts used for workshops attendees.
The program involves creating AWS accounts, creating users, deleting users, and deleting resources 

-----------------------------
PREREQUISITES
-----------------------------
1. Install JQ

-----------------------------
GUIDES
-----------------------------
CREATING ACCOUNTS AND USERS
1. Run create_aws_accounts.sh to create AWS accounts. Change the range in for-loop bracket {} as necessary to define how many accounts you need
2. Run create_account_alias.sh to generate alias to your accounts
3. Set AWS_USER_PASSWORD environment variable and run create_users.sh
4. Run check_aws_accounts.sh to check whether accounts and users were created, and to list IAM users.

RESTRICTING ACCESS FOR USERS - IMPORTANT!!!
1. Go to AWS Organization in your parent account via AWS console
2. Organize all the newly created accounts into 1 Organizational Unit
3. Apply SCP with deny access for:
   3.1 deleting the profile role we created, or otherwise we cannot access the child account with assume role anymore if they delete it
   3.2 detaching the policy attached to that profile role from that role e.g. AdministratorAccess
   3.3 deleting any IAM policy
   3.4 All access to AWS Organization
NOTE: This may be automated in the future -> area of improvement!

DELETING USERS AND RESOURCES
1. Run delete_users.sh
2. Check nuke-config.yml and run delete_resources.sh

PREPARING FOR ANOTHER WORKSHOP
1. Just run create_users.sh, since the accounts are already created and never deleted.

-----------------------------
NOTES
-----------------------------
1. delete_resource.sh needs aws-nuke program. You can use the included aws-nuke binary that only works in Linux environment (e.g. Cloud9)
   Or, you can download other aws-nuke binary, or build your own. Refer to https://github.com/rebuy-de/aws-nuke
2. If you use Cloud9, you need to disable its temporary credentials feature, and user accessKey + secretKey for an IAM user instead
