resource "aws_default_network_acl" "default" {
  default_network_acl_id = "${module.network.vpc_nacl_id}"

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

/*--------------------------------------------------
 * Web Security
 *-------------------------------------------------*/
resource "aws_security_group" "web" {
  name = "http"
  description = "Security group for ELB"
  vpc_id = "${module.network.vpc_id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
 * Database Security
 *-------------------------------------------------*/
resource "aws_security_group" "database" {
  name = "mysql"
  description = "Security group for MySQL"
  vpc_id = "${module.network.vpc_id}"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    security_groups = ["${module.network.vpc_sg}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = ["${module.network.vpc_sg}"]
  }

  tags {
    app = "${var.app_name}"
    env = "${var.environment}"
  }
}

/*--------------------------------------------------
 * Cache Security
 *-------------------------------------------------*/
resource "aws_security_group" "cache" {
  name = "cache"
  description = "Security group for Memcached"
  vpc_id = "${module.network.vpc_id}"

  ingress {
    from_port = 11211
    to_port = 11211
    protocol = "tcp"
    security_groups = ["${module.network.vpc_sg}"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = ["${module.network.vpc_sg}"]
  }

  tags {
    app = "${var.app_name}"
    env = "${var.environment}"
  }
}
