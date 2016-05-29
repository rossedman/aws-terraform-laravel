/*--------------------------------------------------
 * Variables
 *-------------------------------------------------*/
variable "amount" {}
variable "subnet_ids" {}

/*--------------------------------------------------
 * NAT
 *-------------------------------------------------*/
resource "aws_eip" "nat" {
  count = "${var.amount}"
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  count = "${var.amount}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id = "${element(split(",", var.subnet_ids), count.index)}"
}

/*--------------------------------------------------
 * Output
 *-------------------------------------------------*/
output "ips" {
  value = "${join(",", aws_eip.nat.*.id)}"
}

output "ids" {
  value = "${join(",", aws_nat_gateway.nat.*.id)}"
}
