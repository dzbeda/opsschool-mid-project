output "public-subnet-id"{
    value = aws_subnet.public_subnet.*.id
}
output "private-subnet-id"{
    value = aws_subnet.private_subnet.*.id
}
output "alb1-security-group-id"{
    value = aws_security_group.alb1_sg.id
}
output "alb1-dns-name"{
    value = aws_alb.alb1.dns_name
}