
/*--------------------------------------------------
 * Subnets
 *-------------------------------------------------*/
module "subnets_public" {
  source = "./subnet"
  azs = "${var.azs}"
  cidrs = "${var.public_subnets}"
  vpc_id = "${module.vpc.id}"
  public = true

  app_name = "${var.app_name}"
  environment = "${var.environment}"
}

module "subnets_private" {
  source = "./subnet"
  azs = "${var.azs}"
  cidrs = "${var.private_subnets}"
  vpc_id = "${module.vpc.id}"
  public = false

  app_name = "${var.app_name}"
  environment = "${var.environment}"
}

module "nat_gateways" {
  source = "./nat"
  amount = "${length(compact(split(",", var.public_subnets)))}"
  subnet_ids = "${module.subnets_public.ids}"
}

/*--------------------------------------------------
 * Private Subnet Routing
 * route each subnet through a nat gateway
 *-------------------------------------------------*/
 resource "aws_route_table" "private" {
   count = "${length(compact(split(",", var.public_subnets)))}"
   vpc_id = "${module.vpc.id}"

   route {
     cidr_block = "0.0.0.0/0"
     nat_gateway_id = "${element(split(",", module.nat_gateways.ids), count.index)}"
   }

   tags {
     app = "${var.app_name}"
     env = "${var.environment}"
   }
 }

 resource "aws_route_table_association" "private" {
   count = "${length(compact(split(",", var.private_subnets)))}"
   subnet_id = "${element(split(",", module.subnets_private.ids), count.index)}"
   route_table_id  = "${element(aws_route_table.private.*.id, count.index)}"
 }

/*--------------------------------------------------
 * Public Subnet Routing
 * route every public subnet through internet gateway
 *-------------------------------------------------*/
resource "aws_route_table" "public" {
  vpc_id = "${module.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${module.vpc.gateway_id}"
  }

  tags {
    app = "${var.app_name}"
    env = "${var.environment}"
  }
}

resource "aws_route_table_association" "public" {
  count = "${length(compact(split(",", var.public_subnets)))}"
  subnet_id = "${element(split(",", module.subnets_public.ids), count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}
