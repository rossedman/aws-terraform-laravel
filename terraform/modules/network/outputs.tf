/*--------------------------------------------------
 * Outputs
 *-------------------------------------------------*/
output "public_ids" {value = "${module.subnets_public.ids}"}
output "private_ids" {value = "${module.subnets_private.ids}"}
output "dns_zone" {value = "${aws_route53_zone.private.zone_id}"}
output "vpc_id" {value = "${module.vpc.id}"}
output "vpc_cidr" {value = "${module.vpc.cidr}"}
output "vpc_sg" {value = "${module.vpc.sg_id}"}
output "vpc_nacl_id" {value = "${module.vpc.nacl_id}"}
output "vpc_gateway_id" {value = "${module.vpc.gateway_id}"}
