output "vpcid"{
    value = module.vpc.vpcid
}
output "gwid" {
    value = module.vpc.gwid
}
output "private-subnet-id"{
    value = module.network.private-subnet-id
}
output "public-subnet-id"{
    value = module.network.public-subnet-id
}
output "ansible-server-public-ip"{
    value = module.ansible-server.ansible-server-public-ip
}
output "ansible-server-private-ip"{
    value = module.ansible-server.ansible-server-private-ip
}
output "consul-server-private-ip" {
    value = module.consul-server.consul-server-private-ip
}
output "consul-server-target-group-arn" {
    value = module.consul-server.consul-server-target-group-arn
}