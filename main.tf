resource "aws_s3_bucket" "example" {
  bucket = "mtfbucket"

  tags = {
    Name        = "mtfbucket"
    Environment = "Dev"
  }
}