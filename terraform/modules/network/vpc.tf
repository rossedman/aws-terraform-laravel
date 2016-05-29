module "vpc" {
  source = "./vpc"
  cidr = "${var.cidr}"

  app_name = "${var.app_name}"
  environment = "${var.environment}"
}
