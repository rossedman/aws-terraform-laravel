/*--------------------------------------------------
 * Launch Configuration
 *-------------------------------------------------*/
resource "aws_launch_configuration" "as_conf" {
  image_id = "${lookup(var.aws_linux_amis_ebs, var.region)}"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.private.id}"
  associate_public_ip_address = false
  iam_instance_profile = "${aws_iam_instance_profile.ec2.id}"
  security_groups = [
    "${module.network.vpc_sg}",
    "${aws_security_group.web.id}"
  ]
  user_data = "${file("userdata.sh")}"
  lifecycle { create_before_destroy = true }
}

/*--------------------------------------------------
 * Autoscaling Group
 *-------------------------------------------------*/
resource "aws_autoscaling_group" "web" {
  min_size = 2
  max_size = 6
  health_check_type = "ELB"
  launch_configuration = "${aws_launch_configuration.as_conf.name}"
  load_balancers = ["${aws_elb.web_lb.id}"]
  min_elb_capacity = 2
  vpc_zone_identifier = ["${split(",", module.network.private_ids)}"]

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
  cooldown = 120
  autoscaling_group_name = "${aws_autoscaling_group.web.name}"
}

resource "aws_autoscaling_policy" "remove_capacity" {
  name = "RemoveCapacityPolicy"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 120
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
  period = "60"
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
  period = "60"
  statistic = "Average"
  threshold = "30"
  dimensions {
      AutoScalingGroupName = "${aws_autoscaling_group.web.name}"
  }
  alarm_description = "This metric monitor ec2 cpu utilization"
  alarm_actions = ["${aws_autoscaling_policy.remove_capacity.arn}"]
}
