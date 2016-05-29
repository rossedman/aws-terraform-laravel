
```sh
# deploy infrastructure
cd terraform
terraform get
terraform apply

# create bucket if it doesn't exist
aws s3 mb s3://testapp.storage --region us-west-2

# set deploy variables
git config aws-codedeploy.application-name <app_name>
git config aws-codedeploy.s3bucket testapp.storage
git config aws-codedeploy.deployment-group <group_name>

# deploy code to instances
./deploy
```
