output "bastion_ip" {
  value = "${module.bastion.ip}"
}

output "address" {
  value = "${aws_elb.web_lb.dns_name}"
}
