aws_region = "us-east-1"
vpc_cidr = "10.0.0.0/16"
tag_enviroment = "production"
project_name = "mid-project"
private-subnet-block = ["10.0.1.0/24","10.0.2.0/24"]
public-subnet-block = ["10.0.3.0/24","10.0.4.0/24"]
availability_zone = ["us-east-1a", "us-east-1b"]
public_key_path = "opschoolaws.pub"
nginx-ami = "ami-04505e74c0741db8d"
instance-type = "t2.micro"
db-ami = "ami-04505e74c0741db8d"
private_key_file_name = "mid-project-key.pem"
consul-instance-type = "t2.micro"
jenkins-node-instance-type = "t2.micro"
jenkins-server-instance-type = "t2.micro"
eks_cluster_name = "mid-project-eks-cluster"
create_ansible_server = false