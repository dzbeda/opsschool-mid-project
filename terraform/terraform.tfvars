aws_region = "us-east-1"
vpc_cidr = "10.0.0.0/16"
tag_enviroment = "production"
project_name = "final-project"
private-subnet-block = ["10.0.1.0/24","10.0.2.0/24"]
public-subnet-block = ["10.0.3.0/24","10.0.4.0/24"]
availability_zone = ["us-east-1a", "us-east-1b"]
private_key_file_name = "final-project-key.pem"
create-elastic-server = true
elastic-server-instance-type = "t2.medium"
create-consul-server = true
number-of-consul-servers = 3
consul-instance-type = "t2.micro"
create-jenkins-master = true
jenkins-server-instance-type = "t2.micro"
create-jenkins-node = true
number-of-jenkins-nodes = 1
jenkins-node-instance-type = "t2.medium"
eks_cluster_name = "mid-project-eks-cluster"
create_ansible_server = false
bastion_enable_ip_for_ssh = "18.212.183.136/32"
domain-name = "zbeda.site"
jenkins-domain-name-record-extantion = "jenkins"
consul-domain-name-record-extantion = "consul"
kandula-domain-name-record-extantion = "kandula"
elastic-domain-name-record-extantion = "elastic"
app_name = "kandulaweb"
app_task = "Kandula"
app_owner = "dudu"
created_by ="duduzbeda"
rds-engine = "postgres"
rds_username = "kandula_dev"
rds_password = "thispassword"