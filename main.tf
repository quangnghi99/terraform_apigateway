provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Name = "lambda-api-gateway"
    }
  }
}