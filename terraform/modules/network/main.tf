## Public Subnet ##

resource "aws_subnet" "public_subnet" {
  count = var.number_of_public_subnets
  cidr_block = var.public-subnet-block[count.index]
  availability_zone = var.availability_zone[count.index]
  vpc_id = var.vpc_id
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public-subnet-${count.index+1}"
    enviroment = var.tag_enviroment
  }
}

## Public route ##

resource "aws_route_table" "route-table-public-subnet" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }

  tags = {
    Name = "${var.project_name}-public-subnet-roue"
    enviroment = var.tag_enviroment
  }
}

resource "aws_route_table_association" "public-subnet" {
  count = var.number_of_public_subnets
  route_table_id = aws_route_table.route-table-public-subnet.id
  subnet_id = aws_subnet.public_subnet.*.id[count.index]
}

## NAT GW ##
resource "aws_eip" "nat-elip" {
  count = var.number_of_public_subnets
}

resource "aws_nat_gateway" "nat-gw" {
  count = var.number_of_public_subnets
  allocation_id = aws_eip.nat-elip.*.id[count.index]
  subnet_id     = aws_subnet.public_subnet.*.id[count.index]
  tags = {
    Name = "${var.project_name}-nat-gw-${count.index + 1}"
    enviroment = var.tag_enviroment
  }
}

## private Subnet ##

resource "aws_subnet" "private_subnet" {
  count = var.number_of_private_subnets
  cidr_block = var.private-subnet-block[count.index]
  availability_zone = var.availability_zone[count.index]
  vpc_id = var.vpc_id
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project_name}-private-subnet-${count.index+1}"
    enviroment = var.tag_enviroment
  }
}

## private route ##

resource "aws_route_table_association" "private-subnet" {
  count = var.number_of_private_subnets
  route_table_id = aws_route_table.route-table-private-subnet[count.index].id
  subnet_id = aws_subnet.private_subnet.*.id[count.index]
}

resource "aws_route_table" "route-table-private-subnet" {
  count = var.number_of_private_subnets
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
