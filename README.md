# AWS Terraform PHP Application

## Quickstart
```sh
# deploy infrastructure
cd terraform && terraform get
terraform plan
terraform apply

# create bucket if it doesn't exist
aws s3 mb s3://testapp.storage --region us-west-2

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

- [ ] Add Elasticache Cluster
- [ ] Add CloudFront
- [X] Finish installing CloudTrail agent (http://docs.aws.amazon.com/AmazonCloudWatch/latest/DeveloperGuide/mon-scripts.html)
- [X] ELB Register/Deregister : ASG Standby
- [ ] DNS Failover when instances are down
- [ ] Set autoscaling policy to read memory
- [ ] Customize CloudTrail logs
- [ ] Add NACL to VPC
- [ ] Add frontend build process to app
- [ ] Build out app
- [ ] Tighten down policies
- [ ] Make security groups more dynamic
