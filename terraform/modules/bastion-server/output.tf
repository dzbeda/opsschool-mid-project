output "bastion-server-public-ip" {
    value = aws_instance.bastion_server.public_ip
}
output "bastione-server-private-ip" {
    value = aws_instance.bastion_server.private_ip
}