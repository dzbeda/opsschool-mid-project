output "ansible-server-public-ip" {
    value = aws_instance.ansible_server.public_ip
}
output "ansible-server-private-ip" {
    value = aws_instance.ansible_server.private_ip
}