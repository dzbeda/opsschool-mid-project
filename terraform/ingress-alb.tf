data "aws_eks_cluster" "target" {
  name = var.eks_cluster_name
  depends_on = [module.eks-cluster]
}
data "aws_eks_cluster_auth" "aws_iam_authenticator" {
  name = data.aws_eks_cluster.target.name
  depends_on = [module.eks-cluster]
}
data "aws_caller_identity" "current" {}
provider "kubernetes" {
  alias = "eks"
  config_path            = "~/.kube/config"
  config_context         = "arn:aws:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${var.eks_cluster_name}"
  host                   = data.aws_eks_cluster.target.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
  #load_config_file       = false
}

module "alb-ingress-controller" {
  depends_on = [module.eks-cluster]
  source  = "iplabs/alb-ingress-controller/kubernetes"
  version = "3.4.0"
  providers = {
    kubernetes = kubernetes.eks
  }
  aws_vpc_id =  module.vpc.vpcid
  k8s_cluster_type = "eks"
  k8s_namespace = "kube-system"
  aws_region_name  = var.aws_region
  k8s_cluster_name = data.aws_eks_cluster.target.name
  aws_tags = {
    Name = "IngressCtrl-${var.project_name}"
    tag_enviroment= var.tag_enviroment
    project_name = var.project_name
    Purpose   = "Kubernetes"
    App_name  = var.app_name
    Task      = var.app_task
    Owner     = var.app_owner
    CreatedBy = var.created_by
  }
}