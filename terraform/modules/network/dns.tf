variable "internal_domain" {}

resource "aws_route53_zone" "private" {
  name = "${var.internal_domain}"
  vpc_id = "${module.vpc.id}"
}

output "dns_zone" {
  value = "${aws_route53_zone.private.zone_id}"
}
