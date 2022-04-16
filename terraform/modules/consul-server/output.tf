output "consul-server-private-ip" {
    value = aws_instance.consul_server.*.private_ip
}
output "consul-server-target-group-arn" {
    value = aws_alb_target_group.consul-server.arn
}