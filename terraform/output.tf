output "vpcid"{
    value = module.vpc.vpcid
}
output "private-subnet"{
    value = module.private_subnet.privatesubnetid
}
output "public-subnet"{
    value = module.public_subnet.publicsubnetid
}