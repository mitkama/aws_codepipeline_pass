variable "check" {
  type = "string"
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-tf-log-bucket"
  acl = "log-delivery-write"
}
resource "aws_s3_bucket" "foo" {
  // 23. AWS S3 buckets are accessible to public (high)
  // $.resource[*].aws_s3_bucket exists and ($.resource[*].aws_s3_bucket.*[*].*.acl anyEqual public-read-write or $.resource[*].aws_s3_bucket.*[*].*.acl anyEqual public-read)
  acl = "public-read-write"

  bucket = "foo_name"
  // 24. AWS S3 Object Versioning is disabled (medium)
  // $.resource[*].aws_s3_bucket exists and ($.resource[*].aws_s3_bucket.*[*].*.versioning[*].enabled does not exist or $.resource[*].aws_s3_bucket.*[*].*.versioning[*].enabled anyFalse)
  versioning {
    enabled = false
  }
  // 1. AWS S3 CloudTrail buckets for which access logging is disabled ()
  // $.resource[*].aws_cloudtrail[*].*[*].enable_logging anyFalse
  // UPDATED Policy: "AWS Access logging not enabled on S3 buckets"
  // $.resource.aws_s3_bucket exists and ($.resource.aws_s3_bucket[*].logging anyNull or $.resource.aws_s3_bucket[*].logging[*].target_bucket !exists or $.resource.aws_s3_bucket[*].logging[*].target_bucket anyNull)
  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
}

