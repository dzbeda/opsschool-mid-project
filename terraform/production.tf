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
     iam_instance_profile   = aws_iam_instance_profile.ec2-role.name
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
}

module "consul-server"{
     consul_number_of_server = 3
     source = "./modules/consul-server"
     ami_id = "ami-00ddb0e5626798373"
     instance_type = var.consul-instance-type
     private_subnet_id = module.network.private-subnet-id
     tag_enviroment= var.tag_enviroment
     project_name = var.project_name
     vpc_id = module.vpc.vpcid
     key_name  = aws_key_pair.mid_project_key.key_name
     iam_instance_profile   = aws_iam_instance_profile.ec2-role.name
     jenkins_security_group_id = module.jenkins.jenkins-security-group-id
     alb1_security_group_id = module.network.alb1-security-group-id
}
module "jenkins"{
     source = "./modules/jenkins"
     jenkins_server_ami_id = "ami-0e8e33e291ad9f440"
     jenkins_client_ami_id = "ami-0e472ba40eb589f49"
     jenkins_nodes_number_of_server = 2
     jenkins-server-instance-type = var.jenkins-server-instance-type
     jenkins-node-instance-type = var.jenkins-node-instance-type
     private_subnet_id = module.network.private-subnet-id
     tag_enviroment= var.tag_enviroment
     project_name = var.project_name
     vpc_id = module.vpc.vpcid
     key_name  = aws_key_pair.mid_project_key.key_name
     private_key_file_name = var.private_key_file_name
     iam_instance_profile   = aws_iam_instance_profile.ec2-role.name
     alb1_security_group_id = module.network.alb1-security-group-id
}
module "eks-cluster"{
  source = "./modules/eks-cluster"
  vpc_id = module.vpc.vpcid
  subnet_ids   = module.network.private-subnet-id
  eks_cluster_name = var.eks_cluster_name
  tag_enviroment= var.tag_enviroment
  project_name = var.project_name
}

resource "time_sleep" "wait_90_seconds" {
  depends_on = [module.eks-cluster]
  create_duration = "90s"
}
resource "null_resource" "update_kubectl_configuration" {
  depends_on = [time_sleep.wait_90_seconds]
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.eks_cluster_name}"
  }
}
resource "null_resource" "copy_private_key" {
  depends_on = [module.bastion-server]
  provisioner "local-exec" {
    command = "./create_private.sh"
  }
}
resource "null_resource" "Update_ansible_cfg" {
  depends_on = [module.bastion-server]
  provisioner "local-exec" {
    command = "sed -i -r 's/(\\b[0-9]{1,3}\\.){3}[0-9]{1,3}\\b'/${module.bastion-server.bastion-server-public-ip}/ ../ansible/ansible.cfg"
  }
}