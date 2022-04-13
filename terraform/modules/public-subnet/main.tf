
resource "aws_subnet" "public_subnet" {
  count = var.number_of_subnets
  cidr_block = var.public-subnet-block[count.index]
  availability_zone = var.availability_zone[count.index]
  vpc_id = var.vpc_id
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public-subnet-${count.index+1}"
    env = var.tag_enviroment
  }
}