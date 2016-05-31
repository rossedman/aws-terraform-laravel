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
- [ ] Memcached / Laravel Cache Test Endpoints
- [ ] Make Ansible playbook more dynamic
