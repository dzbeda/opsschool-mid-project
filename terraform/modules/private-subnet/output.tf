output "privatesubnetid"{
    value = aws_subnet.private_subnet.*.id
}