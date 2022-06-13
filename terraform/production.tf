module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    tag_enviroment= var.tag_enviroment
    project_name = var.project_name
    
}
module "network" {
     source = "./modules/network"
     vpc_id = module.vpc.vpcid
     number_of_public_subnets = 2
     number_of_private_subnets = 2
     public-subnet-block = var.public-subnet-block
     private-subnet-block = var.private-subnet-block
     availability_zone = var.availability_zone
     gateway_id = module.vpc.gwid
     tag_enviroment= var.tag_enviroment
     project_name = var.project_name
     consul_target_group_arn = module.consul-server.consul-server-target-group-arn
     jenkins_server_target_group_arn = module.jenkins.jenkins-server-target-group-arn
     domain-name = var.domain-name
     jenkins-domain-name = var.jenkins-domain-name-record-extantion
     consul-domain-name = var.consul-domain-name-record-extantion
     eks_cluster_name = var.eks_cluster_name
}
module "ansible-server"{
     source = "./modules/ansible-server"
     ansible_number_of_servers  = var.create_ansible_server ? 1 : 0
     ami_id = "ami-04505e74c0741db8d"
     instance_type = var.ansible_server_instance-type
     private_subnet_id = module.network.private-subnet-id[0]
     tag_enviroment= var.tag_enviroment
     project_name = var.project_name
     vpc_id = module.vpc.vpcid
     key_name  = aws_key_pair.mid_project_key.key_name
     iam_instance_profile   = aws_iam_instance_profile.ansible-role.name
}
module "bastion-server"{
     source = "./modules/bastion-server"
     ami_id = "ami-04505e74c0741db8d"
     instance_type = var.bastion_server_instance-type
     subnet_id = module.network.public-subnet-id[0]
     tag_enviroment= var.tag_enviroment
     project_name = var.project_name
     vpc_id = module.vpc.vpcid
     key_name  = aws_key_pair.mid_project_key.key_name
     ssh_enable_ip = var.bastion_enable_ip_for_ssh
}

module "consul-server"{
     depends_on = [module.bastion-server]
     consul_number_of_server = var.create-consul-server ? var.number-of-consul-servers : 0
     source = "./modules/consul-server"
     ami_id = "ami-00ddb0e5626798373"
     instance_type = var.consul-instance-type
     private_subnet_id = module.network.private-subnet-id
     tag_enviroment= var.tag_enviroment
     project_name = var.project_name
     vpc_id = module.vpc.vpcid
     key_name  = aws_key_pair.mid_project_key.key_name
     iam_instance_profile   = aws_iam_instance_profile.consul-role.name
     jenkins_security_group_id = module.jenkins.jenkins-security-group-id
     alb1_security_group_id = module.network.alb1-security-group-id
}
module "jenkins"{
     depends_on = [time_sleep.wait_60_seconds]
     source = "./modules/jenkins"
     jenkins_server_ami_id = "ami-02d20a09c983588c2"
     jenkins_client_ami_id = "ami-0e472ba40eb589f49"
     jenkins_master_number_of_servers = var.create-jenkins-master ? 1 : 0
     jenkins_nodes_number_of_server = var.create-jenkins-node ? var.number-of-jenkins-nodes : 0
     jenkins-server-instance-type = var.jenkins-server-instance-type
     jenkins-node-instance-type = var.jenkins-node-instance-type
     private_subnet_id = module.network.private-subnet-id
     tag_enviroment= var.tag_enviroment
     project_name = var.project_name
     vpc_id = module.vpc.vpcid
     key_name  = aws_key_pair.mid_project_key.key_name
     private_key_file_name = var.private_key_file_name
     iam_instance_profile   = aws_iam_instance_profile.jenkins-role.name
     alb1_security_group_id = module.network.alb1-security-group-id
     aws_region = var.aws_region
     eks_cluster_name = var.eks_cluster_name
}
module "eks-cluster"{
  source = "./modules/eks-cluster"
  vpc_id = module.vpc.vpcid
  aws_region = var.aws_region
  subnet_ids   = module.network.private-subnet-id
  eks_cluster_name = var.eks_cluster_name
  tag_enviroment= var.tag_enviroment
  project_name = var.project_name
  jenkins_role_name = aws_iam_role.jenkins-role.name
  jenkins_role_arn = aws_iam_role.jenkins-role.arn
  app_name   = var.app_name
  app_task   = var.app_task 
  app_owner  = var.app_owner
  created_by = var.created_by
}
resource "time_sleep" "wait_60_seconds" {
  depends_on = [module.eks-cluster]
  create_duration = "60s"
}
resource "null_resource" "update_kubectl_configuration" {
  depends_on = [time_sleep.wait_60_seconds]
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.eks_cluster_name}"
  }
  provisioner "local-exec" {
    command = "kubectl create secret generic kandula-secret --from-literal=AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID --from-literal=AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
  }
}
# resource "null_resource" "ansible_configuration" {
#   depends_on = [time_sleep.wait_60_seconds]
#   provisioner "local-exec" {
#     command = "./create_private.sh"
#   }
#   provisioner "local-exec" {
#     command = "sed -i -r 's/(\\b[0-9]{1,3}\\.){3}[0-9]{1,3}\\b'/${module.bastion-server.bastion-server-public-ip}/ ../ansible/ansible.cfg"
#   }
#   provisioner "local-exec" {
#     command = "ansible-playbook -i ../ansible/aws_ec2.yml ../ansible/mid-project-installation.yaml"
#     environment = {
#       ANSIBLE_CONFIG = "../ansible/ansible.cfg"
#       AWS_REGION = var.aws_region
#       EKS_CLUSTER_NAME = var.eks_cluster_name
#     }
#   }
# }