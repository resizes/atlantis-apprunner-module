provider "aws" {
  region = "REGION"

  assume_role {
    role_arn = "arn:aws:iam::XXXXXXXXXXX:role/atlantis"
  }
}

terraform {
  required_version = "~> 1.10"

  backend "s3" {
    bucket = "terraform-states-bucket"
    key    = "XXXXXXXXXXX/atlantis/terraform.tfstate"
    region = "REGION"
    acl    = "bucket-owner-full-control"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
