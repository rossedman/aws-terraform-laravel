# AWS CodeDeploy Example
This is a sample application and configuration to deploy through AWS CodeDeploy.
This will configure a simple PHP server and deploy a few packages.

## Set Git Variables
```
git config aws-codedeploy.application-name TestApp
git config aws-codedeploy.s3bucket development.merlin.lo
git config aws-codedeploy.deployment-group AutoScalingWeb
```
