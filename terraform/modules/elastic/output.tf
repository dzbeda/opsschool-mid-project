output "elastic-server-private-ip" {
    value = aws_instance.elastic_server.*.private_ip
}
output "elastic-server-target-group-arn" {
    value = aws_alb_target_group.elastic-server.arn
}
output "elastic-security-group-id"{
    value = aws_security_group.elastic.id
}