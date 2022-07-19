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
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb" = "1"
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
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
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

## Application Load Balancer - alb ##

resource "aws_alb" "alb1" {
  name = "alb1"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb1_sg.id]
  subnets = [for subnet in aws_subnet.public_subnet.*.id : subnet]
  tags = {
    Name = "alb1-${var.project_name}"
    enviroment = var.tag_enviroment
  }
}

resource "aws_alb_listener" "consul" {
  depends_on = [time_sleep.wait_for_certificate_verification]
  load_balancer_arn = aws_alb.alb1.arn
  certificate_arn = aws_acm_certificate.zbeda_site.arn
  port              = "8500"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = var.consul_target_group_arn
  }
}

resource "aws_alb_listener" "jenkins" {
  depends_on = [time_sleep.wait_for_certificate_verification]
  load_balancer_arn = aws_alb.alb1.arn
  certificate_arn = aws_acm_certificate.zbeda_site.arn
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = var.jenkins_server_target_group_arn
  }
}
resource "aws_alb_listener" "elastic" {
  depends_on = [time_sleep.wait_for_certificate_verification]
  load_balancer_arn = aws_alb.alb1.arn
  certificate_arn = aws_acm_certificate.zbeda_site.arn
  port              = "5601"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = var.elastic_server_target_group_arn
  }
}

## APB security group
resource "aws_security_group" "alb1_sg" {
  name ="alb1-security-group"
  vpc_id = var.vpc_id
  ## Incoming roles
  ingress {
    from_port = 8500
    to_port =  8500
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow consul UI access"
  }
  ingress {
    from_port = 5601
    to_port =  5601
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow elastic UI access"
  }
  ingress {
    from_port = 443
    to_port =  443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow jenkins UI secure access"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "alb1-sg-${var.project_name}"
    env = var.tag_enviroment
  }
}
resource "aws_route53_record" "jenkins_record" {
  zone_id = data.aws_route53_zone.primary_domain.zone_id
  name    = "${var.jenkins-domain-name}.${var.domain-name}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_alb.alb1.dns_name]
}
resource "aws_route53_record" "elastic_record" {
  zone_id = data.aws_route53_zone.primary_domain.zone_id
  name    = "${var.elastic-domain-name}.${var.domain-name}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_alb.alb1.dns_name]
}
resource "aws_route53_record" "consul_record" {
  zone_id = data.aws_route53_zone.primary_domain.zone_id
  name    = "${var.consul-domain-name}.${var.domain-name}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_alb.alb1.dns_name]
}

## Create Certificate 
resource "aws_acm_certificate" "zbeda_site" {
  domain_name       = var.domain-name
  subject_alternative_names = ["*.${var.domain-name}"]
  validation_method = "DNS"

  tags = {
    Name = "certificate-${var.project_name}"
    enviroment = var.tag_enviroment
  }
}

data "aws_route53_zone" "primary_domain" {
  name         = var.domain-name
  private_zone = false
}

resource "aws_route53_record" "zbeda_site" {
  for_each = {
    for dvo in aws_acm_certificate.zbeda_site.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.primary_domain.zone_id
}

resource "aws_acm_certificate_validation" "zbeda_site" {
  certificate_arn         = aws_acm_certificate.zbeda_site.arn
  validation_record_fqdns = [for record in aws_route53_record.zbeda_site : record.fqdn]
}
resource "time_sleep" "wait_for_certificate_verification" {
  depends_on = [aws_acm_certificate_validation.zbeda_site]
  create_duration = "60s"
}