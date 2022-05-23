output "jenkins-server-private-ip" {
    value = aws_instance.jenkins_server.*.private_ip
}
output "jenkins-nodes-private-ip" {
    value = aws_instance.jenkins_node.*.private_ip
}
output "jenkins-server-target-group-arn" {
    value = aws_alb_target_group.jenkins-server.arn
}
output "jenkins-security-group-id"{
    value = aws_security_group.jenkins.id
}