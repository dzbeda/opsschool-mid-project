variable "public-subnet-block" {
  type = list(string)
}
variable "private-subnet-block" {
  type = list(string)
}
variable "vpc_id" {}
variable "gateway_id" {}
variable "number_of_public_subnets" {}
variable "number_of_private_subnets" {}
variable "availability_zone" {}
variable "tag_enviroment" {}
variable "project_name" {}
variable "consul_target_group_arn" {}
variable "jenkins_server_target_group_arn" {}
variable "domain-name" {}
variable "jenkins-domain-name" {}
variable "consul-domain-name" {}
