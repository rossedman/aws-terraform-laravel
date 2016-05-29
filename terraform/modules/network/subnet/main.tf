/*--------------------------------------------------
 * Variables
 *-------------------------------------------------*/
variable "azs"    {}
variable "app_name" {}
variable "cidrs"  {}
variable "environment" {}
variable "vpc_id" {}
variable "public" {default = true}

/*--------------------------------------------------
 * Subnet
 *-------------------------------------------------*/
resource "aws_subnet" "mod" {
  count = "${length(compact(split(",", var.cidrs)))}"
  vpc_id = "${var.vpc_id}"
  cidr_block = "${element(split(",", var.cidrs), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  map_public_ip_on_launch = "${var.public}"

  tags {
    app = "${var.app_name}"
    env = "${var.environment}"
  }
}

/*--------------------------------------------------
 * Outputs
 *-------------------------------------------------*/
output "ids" {
  value = "${join(",",aws_subnet.mod.*.id)}"
}
