resource "aws_s3_bucket" "remote_state_any_resource" {
  bucket = var.s3bucketname
  tags = {
    Name        = "Environment"
    Environment = var.s3bucketenv
  }
}

