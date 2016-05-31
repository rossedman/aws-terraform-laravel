# AWS Terraform PHP Application

## Quickstart
```sh
# deploy infrastructure
cd terraform && terraform get
terraform plan
terraform apply

# create bucket if it doesn't exist
aws s3 mb s3://testapp.storage --region us-west-2

# update load balancer name in config/common_functions.sh

# set deploy variables
git config aws-codedeploy.application-name <app_name>
git config aws-codedeploy.s3bucket testapp.storage
git config aws-codedeploy.deployment-group <group_name>

# deploy code to instances
./deploy

# check status of last deployment
./watch
```

## What Does This Build?
Here is a list of all pieces that this repo will put in place for a high availability
Laravel application deployment and lifecycle.

#### Infrastructure
- virtual private cloud
- public and private Subnets for each availability zone
- nat gateways in each private subnet
- bastion host in one public subnet
- security groups
- autoscaling group for web instances
- elastic load balancer
- internet gateway
- routing tables
- route53 domain setup
- internal dns zone
- ec2 userdata
- rds mysql install with multi-az
- elasticache memcached cluster
- codedeploy application
- codedeploy agent on ec2 instances
- iam roles and policies
- internal dns records
- ssh keys

#### Configuration
On CodeDeploy, Ansible scripts will be run locally to configure each autoscaled machine.
This will include this software.
- apache webserver
- php 5.6
- cloudwatch log setup
- aws-cli


## TODO

- [X] Finish installing CloudTrail agent (http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/mon-scripts.html)
- [X] ELB Register/Deregister : ASG Standby
- [X] Add Elasticache Cluster
- [ ] Add CloudFront
- [ ] DNS Failover when instances are down
- [ ] Set autoscaling policy to read memory
- [X] Send laravel.log to CloudTrail
- [ ] Add NACL to VPC
- [ ] Add frontend build process to app (Gulp & NPM)
- [ ] Build out app
- [ ] S3/Laravel Filesystem Setup
- [ ] SQS/Laravel Queue Setup
- [ ] Integration Tests / CodeDeploy Hooks
- [X] Memcached / Laravel Cache Test Endpoints
- [ ] Make Ansible playbook more dynamic
- [ ] Connect Laravel to SES
- [ ] Add [TrustedProxy?](https://github.com/fideloper/TrustedProxy)
