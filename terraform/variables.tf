variable "aws_region" {
  type = string
  description = "Describe the AWS working region"
}
variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}
variable "tag_enviroment" {
  description = "Describe the enviroment"
}
variable "project_name" {
  type = string
  default = "main"
}
variable "ansible_server_instance-type" {
  type = string
  default = "t2.micro"
}
variable "private-subnet-block" {
  type = list(string)
}
variable "public-subnet-block" {
  type = list(string)
}
variable "availability_zone" {}
variable "private_key_file_name" {}
variable "create-consul-server" {}
variable "consul-instance-type" {}
variable "number-of-consul-servers" {}
variable "number-of-jenkins-nodes" {}
variable "create-jenkins-node" {}
variable "jenkins-node-instance-type" {}
variable "create-jenkins-master" {}
variable "jenkins-server-instance-type" {}
variable "create_ansible_server" {}
variable "bastion_server_instance-type" {
  type = string
  default = "t2.micro"
}
variable "eks_cluster_name" {}
locals {
  k8s_service_account_namespace = "default"
  k8s_service_account_name      = "opsschool-sa"
}
variable "bastion_enable_ip_for_ssh" {}
variable "domain-name" {}
variable "jenkins-domain-name-record-extantion" {}
variable "consul-domain-name-record-extantion" {}
variable "kandula-domain-name-record-extantion" {}
variable  "app_name" {}
variable  "app_task" {}
variable  "app_owner" {}
variable  "created_by" {}


