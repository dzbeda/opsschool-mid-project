## VPC
resource "aws_vpc" "vpc-main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags       = {
    Name = var.project_name
    env = var.tag_enviroment
  }
}

## Internet GW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc-main.id
  tags = {
    Name = var.project_name
    env = var.tag_enviroment
  }
}