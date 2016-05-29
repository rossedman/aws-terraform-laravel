/*--------------------------------------------------
 * Variables
 *-------------------------------------------------*/
variable "app_name" {}
variable "cidr" {}
variable "environment" {}
variable "enable_dns_hostnames" {default = true}
variable "enable_dns_support"   {default = true}

/*--------------------------------------------------
 * VPC
 *-------------------------------------------------*/
resource "aws_vpc" "default" {
  cidr_block            = "${var.cidr}"
  enable_dns_hostnames  = "${var.enable_dns_hostnames}"
  enable_dns_support    = "${var.enable_dns_support}"

  tags {
    Name = "${var.environment}-vpc"
    app = "${var.app_name}"
    env = "${var.environment}"
  }
}

/*--------------------------------------------------
 * Internet Gateway
 *-------------------------------------------------*/
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "${var.environment}-internet-gateway"
    app = "${var.app_name}"
    env = "${var.environment}"
  }
}

/*--------------------------------------------------
 * Outputs
 *-------------------------------------------------*/
output "id" {value = "${aws_vpc.default.id}"}
output "cidr" {value = "${aws_vpc.default.cidr_block}"}
output "sg_id" {value = "${aws_vpc.default.default_security_group_id}"}
output "nacl_id" {value = "${aws_vpc.default.default_network_acl_id}"}
output "gateway_id" {value = "${aws_internet_gateway.default.id}"}
