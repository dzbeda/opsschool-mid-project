output "vpcid"{
    value = module.vpc.vpcid
}
output "bastion-server-public-ip"{
    value = module.bastion-server.bastion-server-public-ip
}
output "bastion-server-private-ip"{
    value = module.bastion-server.bastione-server-private-ip
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
output "jenkins-server-private-ip" {
    value = module.jenkins.jenkins-server-private-ip
}
output "jenkins-nodes-private-ip" {
    value = module.jenkins.jenkins-nodes-private-ip
}
output "alb1-dns-name"{
    value = module.network.alb1-dns-name
}
output "eks-oidc_provider_arn" {
  value = module.eks-cluster.oidc_provider_arn
}
output "cluster_endpoint" {
  value = module.eks-cluster.cluster_endpoint
}




