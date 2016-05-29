
## Deploy Code

```bash
cd /to/demo/location && \
aws deploy push
  --application-name TestApp
  --s3-location s3://development.merlin.lo/TestApp
  --source .

aws deploy create-deployment \
  --application-name TestApp \
  --s3-location bucket=development.merlin.lo,key=TestApp,bundleType=zip,eTag=697380dd35f4050db67983b7fc575bca,version=hr3mx4yxnWuU._Dh33n0KoOij9usqeI5 \
  --deployment-group-name AutoScalingWeb \
  --deployment-config-name CodeDeployDefault.OneAtATime \
  --description Test Deployment
```
