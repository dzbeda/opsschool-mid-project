output "consul-server-private-ip" {
    value = aws_instance.consul_server.*.private_ip
}