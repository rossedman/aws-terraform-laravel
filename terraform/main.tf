provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.region}"
}

module "network" {
  source = "../../modules/network"
  azs = "${var.availability_zones}"
  cidr = "${var.vpc_cidr}"
  public_subnets = "${var.public_subnets}"
  private_subnets = "${var.private_subnets}"
  internal_domain = "${var.internal_domain}"

  app_name = "${var.app_name}"
  environment = "${var.environment}"
}

module "bastion" {
  source = "../../modules/network/bastion"
  allowed_to_ssh = "${var.allowed_to_ssh}"
  ami = "${lookup(var.aws_linux_amis_ebs, var.region)}"
  public_key = "${var.bastion_key}"
  security_group_ids = "${module.network.vpc_sg}"
  subnet_id = "${element(split(",", module.network.public_ids), 0)}"
  vpc_id = "${module.network.vpc_id}"
  vpc_cidr = "${module.network.vpc_cidr}"

  app_name = "${var.app_name}"
  environment = "${var.environment}"
}

resource "aws_key_pair" "private" {
  key_name = "private-key"
  public_key = "${file(var.private_key)}"
}
