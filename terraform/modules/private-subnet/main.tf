resource "aws_subnet" "private_subnet" {
  count = var.number_of_subnets
  cidr_block = var.private-subnet-block[count.index]
  availability_zone = var.availability_zone[count.index]
  vpc_id = var.vpc_id
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project_name}-private-subnet-${count.index+1}"
    env = var.tag_enviroment
  }
}