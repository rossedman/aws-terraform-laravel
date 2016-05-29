/*--------------------------------------------------
 * Instance Role
 * this is a test role to see if our private instance can access S3
 *-------------------------------------------------*/
resource "aws_iam_role" "ec2" {
  name = "EC2DeployRole"
  assume_role_policy = "${file("policies/ec2-role.json")}"
}

resource "aws_iam_role_policy" "ec2" {
  name = "EC2DeployPolicy"
  role = "${aws_iam_role.ec2.id}"
  policy = "${file("policies/ec2-policy.json")}"
}

# can you create multiple roles and attach here?
resource "aws_iam_instance_profile" "ec2" {
  name = "EC2DeployInstance"
  roles = ["${aws_iam_role.ec2.name}"]
}
