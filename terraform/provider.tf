terraform {
  required_version = ">= 0.14.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
   backend "s3" {
    bucket = "zbeda-state"
    key = "mid-project/terraform.tfstate"
    region = "us-east-1"
  }
}
# configure provider
provider "aws" {
  region     = var.aws_region
}
