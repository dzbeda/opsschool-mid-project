variable "private-subnet-block" {
  type = list(string)
}
variable "availability_zone" {
  type = list(string)
  #default = ["us-east-1a", "us-east-1b"]
}
variable "number_of_subnets" {}
variable "vpc_id" {}
variable "tag_enviroment" {}
variable "project_name" {}