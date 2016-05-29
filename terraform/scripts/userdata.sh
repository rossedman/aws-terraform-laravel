#!/bin/bash

REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')

# yum install -y ruby aws-cli php56
# usermod -a -G apache ec2-user
# chown -R root:apache /var/www
# chmod 2775 /var/www
# find /var/www -type d -exec chmod 2775 {} +
# find /var/www -type f -exec chmod 0664 {} +
# sudo usermod -a -G apache
# service httpd start

# Install SSM Agent
cd /tmp && curl https://amazon-ssm-$REGION.s3.amazonaws.com/latest/linux_amd64/amazon-ssm-agent.rpm -o amazon-ssm-agent.rpm
yum install -y /tmp/amazon-ssm-agent.rpm
start amazon-ssm-agent

# Install CodeDeploy Agent
aws s3 cp s3://aws-codedeploy-$REGION/latest/install . --region $REGION
chmod +x ./install
./install auto
