resource "aws_s3_bucket" "memesBucket" {
  bucket = local.bucketName
}

resource "aws_s3_bucket_object" "memesBucketObject" {
  for_each = fileset("memy/", "*")
  bucket   = aws_s3_bucket.memesBucket.id
  key      = each.value
  source   = "memy/${each.value}"
  # etag makes the file update when it changes; see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
  etag = filemd5("memy/${each.value}")

}
