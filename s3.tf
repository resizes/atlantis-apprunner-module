resource "aws_s3_bucket" "terraform_states" {
  bucket = "greeneagle-terraform-states"
}

resource "aws_s3_bucket_ownership_controls" "terraform_states_bucket" {
  bucket = aws_s3_bucket.terraform_states.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "terraform_states_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.terraform_states_bucket]

  bucket = aws_s3_bucket.terraform_states.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "terraform_states_versioning" {
  bucket = aws_s3_bucket.terraform_states.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "terraform_states_bucket" {
  bucket = aws_s3_bucket.terraform_states.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowAtlantisAccess"
        Effect    = "Allow"
        Principal = {
          AWS = "arn:aws:iam::063231223530:role/apprunner-atlantis-instance-role"
        }
        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          aws_s3_bucket.terraform_states.arn,
          "${aws_s3_bucket.terraform_states.arn}/*"
        ]
      }
    ]
  })
}