variable "app_name" {}
variable "asg_cooldown" {default = 600}
variable "asg_health_check_grace_period" {default = 600}
variable "asg_healthcheck_type" {default = "ELB"}
variable "asg_min" {default = 2}
variable "asg_max" {default = 6}
variable "asg_min_elb_capacity" {default = 2}
variable "asg_alarm_period" {default = 120}
variable "ec2_ami" {}
variable "ec2_instance_type" {default = "t2.micro"}
variable "ec2_key" {}
variable "ec2_security_groups" {}
variable "ec2_userdata_script" {}
variable "elb_id" {}
variable "environment" {}
variable "private_subnets" {}

/*--------------------------------------------------
 * Instance Role
 * this is a test role to see if our private instance can access S3
 *-------------------------------------------------*/
resource "aws_iam_role" "ec2" {
  name = "EC2DeployRole"
  assume_role_policy = "${file("${path.module}/ec2-role.json")}"
}

resource "aws_iam_role_policy" "ec2" {
  name = "EC2DeployPolicy"
  role = "${aws_iam_role.ec2.id}"
  policy = "${file("${path.module}/ec2-policy.json")}"
}

# can you create multiple roles and attach here?
resource "aws_iam_instance_profile" "ec2" {
  name = "EC2DeployInstance"
  roles = ["${aws_iam_role.ec2.name}"]
}

/*--------------------------------------------------
 * Launch Configuration
 *-------------------------------------------------*/
resource "aws_launch_configuration" "as_conf" {
  image_id = "${var.ec2_ami}"
  instance_type = "${var.ec2_instance_type}"
  key_name = "${var.ec2_key}"
  associate_public_ip_address = false
  iam_instance_profile = "${aws_iam_instance_profile.ec2.id}"
  security_groups = ["${split(",", var.ec2_security_groups)}"]
  user_data = "${file(var.ec2_userdata_script)}"
  lifecycle { create_before_destroy = true }
}

/*--------------------------------------------------
 * Autoscaling Group
 *-------------------------------------------------*/
resource "aws_autoscaling_group" "web" {
  min_size = "${var.asg_min}"
  max_size = "${var.asg_max}"
  health_check_type = "${var.asg_healthcheck_type}"
  launch_configuration = "${aws_launch_configuration.as_conf.name}"
  load_balancers = ["${var.elb_id}"]
  health_check_grace_period = "${var.asg_health_check_grace_period}"
  #min_elb_capacity = "${var.asg_min_elb_capacity}"
  vpc_zone_identifier = ["${split(",", var.private_subnets)}"]

  tag {
    key = "role"
    value = "web"
    propagate_at_launch = true
  }

  tag {
    key = "env"
    value = "${var.environment}"
    propagate_at_launch = true
  }

  tag {
    key = "app"
    value = "${var.app_name}"
    propagate_at_launch = true
  }

  lifecycle { create_before_destroy = true }
}

/*--------------------------------------------------
 * Autoscaling Policies
 *-------------------------------------------------*/
resource "aws_autoscaling_policy" "add_capacity" {
  name = "AddCapacityPolicy"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = "${var.asg_cooldown}"
  autoscaling_group_name = "${aws_autoscaling_group.web.name}"
}

resource "aws_autoscaling_policy" "remove_capacity" {
  name = "RemoveCapacityPolicy"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = "${var.asg_cooldown}"
  autoscaling_group_name = "${aws_autoscaling_group.web.name}"
}

/*--------------------------------------------------
 * Cloudwatch Alerts For Scaling
 *-------------------------------------------------*/
resource "aws_cloudwatch_metric_alarm" "add_capacity" {
  alarm_name = "AddCapacityAlert"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "${var.asg_alarm_period}"
  statistic = "Average"
  threshold = "50"
  dimensions {
      AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
  }
  alarm_description = "This metric monitor ec2 cpu utilization"
  alarm_actions = ["${aws_autoscaling_policy.add_capacity.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "remove_capacity" {
  alarm_name = "RemoveCapacityAlert"
  comparison_operator = "LessThanThreshold"
  evaluation_periods = "2"
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "${var.asg_alarm_period}"
  statistic = "Average"
  threshold = "30"
  dimensions {
      AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
  }
  alarm_description = "This metric monitor ec2 cpu utilization"
  alarm_actions = ["${aws_autoscaling_policy.remove_capacity.arn}"]
}

output "id" {value = "${aws_autoscaling_group.web.id}"}
