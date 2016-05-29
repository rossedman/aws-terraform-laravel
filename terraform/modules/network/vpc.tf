variable "cidr" {}

module "vpc" {
  source = "./vpc"
  cidr = "${var.cidr}"
  
  app_name = "${var.app_name}"
  environment = "${var.environment}"
}

output "vpc_id" {value = "${module.vpc.id}"}
output "vpc_cidr" {value = "${module.vpc.cidr}"}
output "vpc_sg" {value = "${module.vpc.sg_id}"}
output "vpc_nacl_id" {value = "${module.vpc.nacl_id}"}
output "vpc_gateway_id" {value = "${module.vpc.gateway_id}"}
