/*--------------------------------------------------
 * Security Group
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

  ingress {
    from_port = 443
    to_port = 443
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
 * Load Balancer
 *-------------------------------------------------*/
resource "aws_elb" "web_lb" {
  cross_zone_load_balancing = true
  subnets = ["${split(",", module.network.public_ids)}"]
  security_groups = [
    "${module.network.vpc_sg}",
    "${aws_security_group.web.id}"
  ]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:80/"
    interval = 30
  }

  tags {
    app = "${var.app_name}"
    env = "${var.environment}"
  }
}
