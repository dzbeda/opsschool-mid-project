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
     tag_enviroment= var.tag_enviroment
     project_name = var.project_name
     availability_zone = var.availability_zone
}
