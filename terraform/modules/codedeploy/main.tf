variable "app_name" {}
variable "asg_id" {}
variable "group_name" {}
variable "config_name" {default = "CodeDeployDefault.OneAtATime"}

/*--------------------------------------------------
 * Code Deploy Role
 *-------------------------------------------------*/
 resource "aws_iam_role" "code_deploy" {
   name = "CodeDeployRole"
   assume_role_policy = "${file("${path.module}/codedeploy-role.json")}"
 }

 resource "aws_iam_role_policy" "code_deploy" {
   name = "CodeDeployPolicy"
   role = "${aws_iam_role.code_deploy.id}"
   policy = "${file("${path.module}/codedeploy-policy.json")}"
 }

/*--------------------------------------------------
 * Code Deploy App
 *-------------------------------------------------*/
resource "aws_codedeploy_app" "app" {
  name = "${var.app_name}"
}

/*--------------------------------------------------
 * Code Deployment Group
 *-------------------------------------------------*/
resource "aws_codedeploy_deployment_group" "web" {
  app_name = "${aws_codedeploy_app.app.name}"
  deployment_group_name = "${var.group_name}"
  service_role_arn = "${aws_iam_role.code_deploy.arn}"
  autoscaling_groups = ["${var.asg_id}"]
  deployment_config_name = "${var.config_name}"
}
