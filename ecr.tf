resource "aws_ecr_repository" "atlantis" {
  name                 = "atlantis"
  image_tag_mutability = "IMMUTABLE"
  encryption_configuration {
    encryption_type = "AES256"
  }
}
