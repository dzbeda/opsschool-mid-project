resource "aws_subnet" "private_subnet" {
  count = var.number_of_subnets
  cidr_block = var.private-subnet-block[count.index]
  availability_zone = var.availability_zone[count.index]
  vpc_id = var.vpc_id
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project_name}-private-subnet-${count.index+1}"
    enviroment = var.tag_enviroment
  }
}

resource "aws_route_table" "route-table-private-subnet" {
  count = var.number_of_subnets
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
     nat_gateway_id = aws_nat_gateway.nat-gw.*.id[count.index]
  }
  tags = {
    Name = "${var.project_name}-private-subnet-roue"
    enviroment = var.tag_enviroment
  }
}


resource "aws_route_table_association" "private-subnet" {
  count = var.number_of_subnets
  route_table_id = aws_route_table.route-table-private-subnet.id
  subnet_id = aws_subnet.private_subnet.*.id[count.index]
}