terraform {
  required_version = ">=0.12"
 backend "s3" {
    encrypt = true
    bucket         = "versent-tf-state-hub"
    key            = "./versent/terraform.tfstate"
    region         = "ap-southeast-2"
    # profile        = "default"
    dynamodb_table = "versent-tf-state-table"
  }
}

provider "aws" {
  region  = var.region
  # profile = var.aws_profile
  # profile = "default"
}