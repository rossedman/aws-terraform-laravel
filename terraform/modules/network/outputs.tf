/*--------------------------------------------------
 * Outputs
 *-------------------------------------------------*/
output "public_ids" {
  value = "${module.subnets_public.ids}"
}

output "private_ids" {
  value = "${module.subnets_private.ids}"
}
