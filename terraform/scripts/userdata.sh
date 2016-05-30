#!/bin/bash

REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')

# alternative JQ option
# yum install -y jq
# curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq '.["region"]' -r

# Install SSM Agent
cd /tmp && curl https://amazon-ssm-$REGION.s3.amazonaws.com/latest/linux_amd64/amazon-ssm-agent.rpm -o amazon-ssm-agent.rpm
yum install -y /tmp/amazon-ssm-agent.rpm
start amazon-ssm-agent

# Install CodeDeploy Agent
yum install -y ruby aws-cli
aws s3 cp s3://aws-codedeploy-$REGION/latest/install /home/ec2-user/install --region $REGION
chmod +x /home/ec2-user/install
/home/ec2-user/install auto

# Install Cloudwatch Agent
yum install -y perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https
crontab -l > mycron
echo '*/5 * * * * ~/aws-scripts-mon/mon-put-instance-data.pl --mem-util --disk-space-util --disk-path=/ --from-cron' >> mycron
crontab mycron
rm mycron
