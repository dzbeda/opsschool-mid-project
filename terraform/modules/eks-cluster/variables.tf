variable "vpc_id" {}
variable "subnet_ids" {}
variable "eks_cluster_name" {}
variable "kubernetes_version" {
  default = 1.21
  description = "kubernetes version"
}
locals {
  k8s_service_account_namespace = "default"
  k8s_service_account_name      = "opsschool-sa"
}