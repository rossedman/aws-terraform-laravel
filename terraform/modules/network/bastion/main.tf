variable "allowed_to_ssh" {}
variable "ami" {}
variable "amount" {default = "1"}
variable "app_name" {}
variable "environment" {}
variable "instance_type" {default = "t2.micro"}
variable "public_key" {}
variable "security_group_ids" {default = ""}
variable "subnet_id" {}
variable "vpc_id" {}
variable "vpc_cidr" {}

/*--------------------------------------------------
 * Bastion Key
 * create a new key for instances to use when provisioning
 *-------------------------------------------------*/
resource "aws_key_pair" "bastion" {
  key_name = "bastion-key"
  public_key = "${file(var.public_key)}"
}

/*--------------------------------------------------
 * Bastion SSH
 * Allow SSH into the Bastion box from filtered IP addresses.
 * Allow SSH out only to private CIDR block.
 *-------------------------------------------------*/
resource "aws_security_group" "bastion" {
  name = "bastion"
  description = "Security group for bastion instances that allows SSH traffic. Allows outbound SSH to other instances in the CIDR block"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${split(",", var.allowed_to_ssh)}"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    app = "${var.app_name}"
    env = "${var.environment}"
  }
}

/*--------------------------------------------------
 * Bastion Instances
 * this is a normal Linux instance that we are giving access to
 * private boxes through the security rules. There is nothing
 * else being configured on this box.
 *-------------------------------------------------*/
resource "aws_instance" "bastion" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "${aws_key_pair.bastion.id}"
  subnet_id = "${var.subnet_id}"
  source_dest_check = false
  associate_public_ip_address = true

  vpc_security_group_ids = [
    "${split(",", var.security_group_ids)}",
    "${aws_security_group.bastion.id}"
  ]

  tags {
    Name = "bastion"
    role = "bastion"
    app = "${var.app_name}"
    env = "${var.environment}"
  }
}

/*--------------------------------------------------
 * Outputs
 *-------------------------------------------------*/
 output "ip" {
   value = "${aws_instance.bastion.public_ip}"
 }
