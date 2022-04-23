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
     ami_id = "ami-04505e74c0741db8d"
     instance_type = var.ansible_server_instance-type
     #availability_zone = var.availability_zone[0]
     #subnet_id = module.network.public-subnet-id[0]
     private_subnet_id = module.network.private-subnet-id[0]
     tag_enviroment= var.tag_enviroment
     project_name = var.project_name
     vpc_id = module.vpc.vpcid
     key_name  = aws_key_pair.mid_project_key.key_name
     #private_key_file_name = var.private_key_file_name
     iam_instance_profile   = aws_iam_instance_profile.ec2-role.name
     #depends_on = [local_file.mid_project_key]
}
module "bastion-server"{
     source = "./modules/bastion-server"
     ami_id = "ami-04505e74c0741db8d"
     instance_type = var.bastion_server_instance-type
     #availability_zone = var.availability_zone[0]
     subnet_id = module.network.public-subnet-id[0]
     #private_subnet_id = module.network.private-subnet-id[0]
     tag_enviroment= var.tag_enviroment
     project_name = var.project_name
     vpc_id = module.vpc.vpcid
     key_name  = aws_key_pair.mid_project_key.key_name
     #private_key_file_name = var.private_key_file_name
     #iam_instance_profile   = aws_iam_instance_profile.ec2-role.name
     #depends_on = [local_file.mid_project_key]
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
     ami_id = "ami-0e472ba40eb589f49"
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
