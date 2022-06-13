variable "aws_region" {
  type = string
  description = "Describe the AWS working region"
}
variable "tag_enviroment" {
  description = "Describe the enviroment"
}
variable "project_name" {
  type = string
  default = "main"
}
variable "domain-name" {}
