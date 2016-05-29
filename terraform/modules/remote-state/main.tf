variable "bucket_name" {
  description = "Tag your instances by the app name"
}

variable "region" {
  description = "The AWS region to create resources in."
}

variable "path" {
  description = "Path in S3 to location state file, exp: state/path/terraform.tfstate"
}

resource "aws_s3_bucket" "remote_storage" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  versioning {
    enabled = true
  }
}

output "remote_storage_id" {value = "${aws_s3_bucket.remote_storage.id}"}
output "command" {value = "terraform remote config -backend=s3 -backend-config=\"bucket=${var.bucket_name}\" -backend-config=\"key=${var.path}\" -backend-config=\"region=${var.region}\" -backend-config=\"access_key=$AWS_ACCESS_KEY\" -backend-config=\"secret_key=$AWS_SECRET_KEY\""}
