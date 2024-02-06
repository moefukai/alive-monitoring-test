resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name

  tags = merge(var.tags, {
    Name = "${var.project}-s3-bucket"
  })
}

resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "bucket-encryption" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#allow access from cloudfront distribution
resource "aws_s3_bucket_policy" "cloudfront" {
  bucket = aws_s3_bucket.main.id
  policy = jsondecode(
    {
      "Version" : "2008-10-17",
      "Id" : "PolicyForCloudFrontPrivateContent",
      "Statement" : [
        {
          "Sid" : "AllowCloudFrontServicePrincipal",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "cloudfront.amazonaws.com"
          },
          "Action" : "s3:GetObject",
          "Resource" : "arn:aws:s3:::${aws_s3_bucket.main.id}/*",
          "Condition" : {
            "StringEquals" : {
              "AWS:SourceArn" : "${aws_cloudfront_distribution.main.arn}"
            }
          }
        }
      ]
    }
  )
}

