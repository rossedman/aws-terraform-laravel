variable "aws_access_key" {
  description = "The AWS access key."
}

variable "aws_secret_key" {
  description = "The AWS secret key."
}

variable "app_name" {
  description = "The name of the app resources should be associated with"
}

variable "bastion_key" {
  description = "Public key for bastion host"
}

variable "environment" {
  description = "The name of the environment resources should be associated with"
}

variable "internal_domain" {
  description = "Domain used for internal DNS and private zone"
}

variable "private_key" {
  description = "The public key for private subnet instances"
}

variable "public_domain" {
  description = "Public domain that is already registered with Route53"
}

variable "public_domain_zone_id" {
  description = "Public domain zone id"
}

variable "region" {
  description = "The AWS region to create resources in."
}

variable "availability_zones" {
  description = "The availability zones"
}

variable "vpc_cidr" {
  description = "CIDR for VPC"
}

variable "public_subnets" {
  description = "comma separated cidr blocks"
}

variable "private_subnets" {
  description = "comma separated cidr blocks"
}

variable "allowed_to_ssh" {
  description = "comma separated range of CIDR blocks that will allow SSH"
}

# EBS backed HVM
variable "aws_linux_amis_ebs" {
  default = {
    ap-northeast-1  = "ami-29160d47"
    ap-northeast-2  = "ami-cf32faa1"
    ap-southeast-1  = "ami-1ddc0b7e"
    ap-southeast-2  = "ami-0c95b86f"
    eu-central-1    = "ami-d3c022bc"
    eu-west-1       = "ami-b0ac25c3"
    sa-east-1       = "ami-fb890097"
    us-east-1       = "ami-f5f41398"
    us-west-1       = "ami-6e84fa0e"
    us-west-2       = "ami-d0f506b0"
  }
}

# Instance backed HVM
variable "aws_linux_amis_instant" {
  default = {
    ap-northeast-1  = "ami-35110a5b"
    ap-northeast-2  = "ami-5430f83a"
    ap-southeast-1  = "ami-34dd0a57"
    ap-southeast-2  = "ami-e797ba84"
    eu-central-1    = "ami-26c12349"
    eu-west-1       = "ami-1aad2469"
    sa-east-1       = "ami-018c056d"
    us-east-1       = "ami-54f71039"
    us-west-1       = "ami-4e82fc2e"
    us-west-2       = "ami-3cf4075c"
  }
}
