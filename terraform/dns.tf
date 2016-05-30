
/*--------------------------------------------------
 * Public DNS
 *-------------------------------------------------*/
resource "aws_route53_record" "web" {
  zone_id = "${var.public_domain_zone_id}"
  name = "${var.public_domain}"
  type = "A"

  alias {
    name = "${aws_elb.web_lb.dns_name}"
    zone_id = "${aws_elb.web_lb.zone_id}"
    evaluate_target_health = true
  }
}

/*--------------------------------------------------
 * Internal DNS
 *-------------------------------------------------*/
resource "aws_route53_record" "database" {
  zone_id = "${module.network.dns_zone}"
  name = "db.${var.internal_domain}"
  type = "CNAME"
  records = ["${aws_db_instance.mysql.address}"]
  ttl = 300
}
