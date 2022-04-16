output "publicsubnetid"{
    value = aws_subnet.public_subnet.*.id
}

output "privatesubnetid"{
    value = aws_subnet.private_subnet.*.id
}

