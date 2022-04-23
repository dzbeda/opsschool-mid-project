output "vpcid"{
    value = module.vpc.vpcid
}
# output "gwid" {
#     value = module.vpc.gwid
# }
# output "private-subnet-id"{
#     value = module.network.private-subnet-id
# }
# output "public-subnet-id"{
#     value = module.network.public-subnet-id
# }
output "ansible-server-public-ip"{
    value = module.ansible-server.ansible-server-public-ip
}
output "ansible-server-private-ip"{
    value = module.ansible-server.ansible-server-private-ip
}
output "consul-server-private-ip" {
    value = module.consul-server.consul-server-private-ip
}
# output "consul-server-target-group-arn" {
#     value = module.consul-server.consul-server-target-group-arn
# }
output "jenkins-server-private-ip" {
    value = module.jenkins.jenkins-server-private-ip
}
output "jenkins-nodes-private-ip" {
    value = module.jenkins.jenkins-nodes-private-ip
}
# output "alb1_security_group_id" {
#     value = module.network.alb1-security-group-id
# }
output "alb1-dns-name"{
    value = module.network.alb1-dns-name
}
# output "jenkins-security-group-id"{
#     value = module.jenkins.jenkins-security-group-id
# }
output "bastion-server-public-ip"{
    value = module.bastion-server.bastion-server-public-ip
}
output "bastion-server-private-ip"{
    value = module.bastion-server.bastione-server-private-ip
}