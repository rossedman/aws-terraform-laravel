resource "aws_route53_zone" "private" {
  name = "${var.internal_domain}"
  vpc_id = "${module.vpc.id}"
}
