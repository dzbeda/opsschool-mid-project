output "vpcid"{
    value = module.vpc.vpcid
}
output "gwid" {
    value = module.vpc.gwid
}
output "private-subnet-id"{
    value = module.private_subnet.privatesubnetid
}
output "public-subnet-id"{
    value = module.public_subnet.publicsubnetid
}
output "ansible-server-public-ip"{
    value = module.ansible-server.ansible-server-public-ip
}
output "ansible-server-private-ip"{
    value = module.ansible-server.ansible-server-private-ip
}