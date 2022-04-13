output "publicsubnetid"{
    value = aws_subnet.public_subnet.*.id
}