/*--------------------------------------------------
 * Variables
 *-------------------------------------------------*/
variable "app_name" {}
variable "az_mode" {default = "cross-az"}
variable "availability_zones" {}
variable "environment" {}
variable "maintenance_window" {default = "sun:05:00-sun:09:00"}
variable "instance_type" {default = "cache.m1.small"}
variable "port" {default = "11211"}
variable "private_subnets" {}
variable "security_groups" {}

/*--------------------------------------------------
 * Cache Subnet Groups
 *-------------------------------------------------*/
resource "aws_elasticache_subnet_group" "memcached" {
  name = "private-subnets"
  description = "Private subnet group"
  subnet_ids = ["${split(",", var.private_subnets)}"]
}

/*--------------------------------------------------
 * Cache Cluster
 *-------------------------------------------------*/
resource "aws_elasticache_cluster" "memcached" {
  az_mode = "${var.az_mode}"
  availability_zones = ["${split(",", var.availability_zones)}"]
  cluster_id = "memcached-cluster"
  engine = "memcached"
  node_type = "${var.instance_type}"
  port = "${var.port}"
  maintenance_window = "${var.maintenance_window}"
  num_cache_nodes = "${length(compact(split(",", var.private_subnets)))}"
  parameter_group_name = "default.memcached1.4"
  security_group_ids = ["${split(",", var.security_groups)}"]
  subnet_group_name = "${aws_elasticache_subnet_group.memcached.name}"

  tags {
    app = "${var.app_name}"
    env = "${var.environment}"
  }
}

/*--------------------------------------------------
 * Outputs
 *-------------------------------------------------*/
output "addresses" {
  value = "${join(",", aws_elasticache_cluster.memcached.cache_nodes.*.address)}"
}

output "endpoint" {
  value = "${aws_elasticache_cluster.memcached.configuration_endpoint}"
}
