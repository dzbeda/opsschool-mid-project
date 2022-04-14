output "vpcid" {
    value = aws_vpc.vpc-main.id
}
output "gwid" {
    value = aws_internet_gateway.gw.id
}

