## Public Subnet ##

resource "aws_subnet" "public_subnet" {
  count = var.number_of_public_subnets
  cidr_block = var.public-subnet-block[count.index]
  availability_zone = var.availability_zone[count.index]
  vpc_id = var.vpc_id
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index+1}-${var.project_name}"
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
    Name = "public-subnet-route-${var.project_name}"
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
    Name = "nat-gw-${count.index + 1}-${var.project_name}"
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
    Name = "private-subnet-${var.project_name}-${count.index+1}"
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
    Name = "private-subnet-route-${var.project_name}"
    enviroment = var.tag_enviroment
  }
}

## Consul-server-alb ##

resource "aws_alb" "consul-server-alb" {
  name = "Consul-server-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_consul_server.id]
  subnets = [for subnet in aws_subnet.public_subnet.*.id : subnet]
  tags = {
    Name = "clonsul-server-alb-${var.project_name}"
    enviroment = var.tag_enviroment
  }
}

resource "aws_alb_listener" "consul" {
  load_balancer_arn = aws_alb.consul-server-alb.arn
  port              = "8500"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.consul_target_group_arn
  }
}

## APB security group
resource "aws_security_group" "alb_consul_server" {
  name ="alb-consul-security-group"
  vpc_id = var.vpc_id
  ## Incoming roles
  ingress {
    from_port = 8500
    to_port =  8500
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb-consul-server-sg-${var.project_name}"
    env = var.tag_enviroment
  }
}