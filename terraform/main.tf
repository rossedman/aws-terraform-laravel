provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.region}"
}

/*--------------------------------------------------
 * Network
 *
 * This sets up VPC, Subnets, Internet Gateway,
 * Routing Tables, and more.
 *-------------------------------------------------*/
module "network" {
  source = "modules/network"

  azs = "${var.availability_zones}"
  cidr = "${var.vpc_cidr}"
  public_subnets = "${var.public_subnets}"
  private_subnets = "${var.private_subnets}"
  internal_domain = "${var.internal_domain}"

  app_name = "${var.app_name}"
  environment = "${var.environment}"
}

/*--------------------------------------------------
 * Bastion
 *
 * Establish a jumphost on the public subnet perimeter
 * also sets ssh key for transparent jumping
 *-------------------------------------------------*/
module "bastion" {
  source = "modules/network/bastion"

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

/*--------------------------------------------------
 * Private Key
 *
 * Create key for private instance access
 *-------------------------------------------------*/
resource "aws_key_pair" "private" {
  key_name = "private-key"
  public_key = "${file(var.private_key)}"
}

/*--------------------------------------------------
 * CodeDeploy
 *
 * Setup the deployment pipeline for the EC2 instaces
 *-------------------------------------------------*/
module "codedeploy" {
  source = "modules/codedeploy"
  app_name = "${var.app_name}"
  asg_id = "${module.asg.id}"
  group_name = "web"
}

/*--------------------------------------------------
 * Load Balancer
 *-------------------------------------------------*/
resource "aws_elb" "web_lb" {
  cross_zone_load_balancing = true
  subnets = ["${split(",", module.network.public_ids)}"]
  security_groups = [
    "${module.network.vpc_sg}",
    "${aws_security_group.web.id}"
  ]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 60
  }

  tags {
    app = "${var.app_name}"
    env = "${var.environment}"
  }
}

/*--------------------------------------------------
 * Autoscaling Group
 *
 * sets up web nodes and attaches ELB as well as
 * security groups and userdata
 *-------------------------------------------------*/
module "asg" {
  source = "modules/autoscaling"

  ec2_ami = "${lookup(var.aws_linux_amis_ebs, var.region)}"
  ec2_key = "${aws_key_pair.private.id}"
  ec2_security_groups = "${module.network.vpc_sg},${aws_security_group.web.id}"
  ec2_userdata_script = "scripts/userdata.sh"

  elb_id = "${aws_elb.web_lb.id}"
  private_subnets = "${module.network.private_ids}"

  app_name = "${var.app_name}"
  environment = "${var.environment}"
}

/*--------------------------------------------------
 * Database
 *-------------------------------------------------*/
resource "aws_db_subnet_group" "mysql" {
  name = "mysql"
  description = "Main group of private subnets"
  subnet_ids = ["${split(",",module.network.private_ids)}"]

  tags {
    app_name = "${var.app_name}"
    environment = "${var.environment}"
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage = 5
  engine = "mysql"
  engine_version = "5.6.27"
  instance_class = "db.t2.micro"
  name = "${lower(var.app_name)}"
  username = "admin"
  password = "password"
  port = 3306
  multi_az = true
  storage_encrypted = false
  db_subnet_group_name = "${aws_db_subnet_group.mysql.name}"
  parameter_group_name = "default.mysql5.6"
  vpc_security_group_ids = ["${aws_security_group.database.id}"]
}
