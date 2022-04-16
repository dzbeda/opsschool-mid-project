module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    tag_enviroment= var.tag_enviroment
    project_name = var.project_name
    
}
# module "private_subnet" {
#      source = "./modules/private-subnet"
#      vpc_id = module.vpc.vpcid
#      number_of_subnets = 2
#      private-subnet-block = var.private-subnet-block
#      tag_enviroment= var.tag_enviroment
#      project_name = var.project_name
#      availability_zone = var.availability_zone
# }
# module "public_subnet" {
#      source = "./modules/public-subnet"
#      vpc_id = module.vpc.vpcid
#      number_of_subnets = 2
#      public-subnet-block = var.public-subnet-block
#      availability_zone = var.availability_zone
#      tag_enviroment= var.tag_enviroment
#      project_name = var.project_name
#      gateway_id = module.vpc.gwid
     
# }
module "ansible-server"{
     source = "./modules/ansible-server"
     ami_id = "ami-04505e74c0741db8d"
     instance_type = var.ansible_server_instance-type
     availability_zone = var.availability_zone[0]
     subnet_id = module.network.publicsubnetid[0]
     tag_enviroment= var.tag_enviroment
     project_name = var.project_name
     vpc_id = module.vpc.vpcid
     key_name  = aws_key_pair.mid_project_key.key_name
     private_key_file_name = var.private_key_file_name
     iam_instance_profile   = aws_iam_instance_profile.ec2-role.name
     depends_on = [local_file.mid_project_key]
}
# module "consul-server"{
#      consul_number_of_server = 1
#      source = "./modules/consul-server"
#      ami_id = "ami-00ddb0e5626798373"
#      instance_type = var.ansible_server_instance-type
#      #availability_zone = var.availability_zone[0]
#      subnet_id = module.public_subnet.publicsubnetid[0]
#      tag_enviroment= var.tag_enviroment
#      project_name = var.project_name
#      vpc_id = module.vpc.vpcid
#      key_name  = aws_key_pair.mid_project_key.key_name
#      iam_instance_profile   = aws_iam_instance_profile.ec2-role.name
#      depends_on = [local_file.mid_project_key]
# }

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
     #depends_on = [module.vpc.aws_internet_gateway.gw]
}