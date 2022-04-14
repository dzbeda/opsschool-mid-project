module "vpc" {
    source = "./modules/vpc"
    vpc_cidr = var.vpc_cidr
    tag_enviroment= var.tag_enviroment
    project_name = var.project_name
    
}
module "private_subnet" {
     source = "./modules/private-subnet"
     vpc_id = module.vpc.vpcid
     number_of_subnets = 2
     private-subnet-block = var.private-subnet-block
     tag_enviroment= var.tag_enviroment
     project_name = var.project_name
     availability_zone = var.availability_zone
}
module "public_subnet" {
     source = "./modules/public-subnet"
     vpc_id = module.vpc.vpcid
     number_of_subnets = 2
     public-subnet-block = var.public-subnet-block
     availability_zone = var.availability_zone
     tag_enviroment= var.tag_enviroment
     project_name = var.project_name
     gateway_id = module.vpc.gwid
     
}
module "ansible-server"{
     source = "./modules/ansible-server"
     ami_id = "ami-04505e74c0741db8d"
     instance_type = var.ansible_server_instance-type
     availability_zone = var.availability_zone[0]
     subnet_id = module.public_subnet.publicsubnetid[0]
     tag_enviroment= var.tag_enviroment
     project_name = var.project_name
     vpc_id = module.vpc.vpcid
     key_name  = aws_key_pair.mid_project_key.key_name
}