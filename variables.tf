resource "random_string" "bucket_name" {
  length  = 12
  special = false
  upper   = false
}

locals {
  #type    = string
  bucketName = random_string.bucket_name.result
}
