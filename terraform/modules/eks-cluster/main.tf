resource "kubernetes_service_account" "opsschool_sa" {
  depends_on = [module.eks]
  metadata {
    name      = local.k8s_service_account_name
    namespace = local.k8s_service_account_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.iam_assumable_role_admin.iam_role_arn
    }
  }
}
resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "eks-worker-management"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "eks-sg-${var.project_name}"
    env = var.tag_enviroment
  }
}
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.21.0"
  cluster_name    = var.eks_cluster_name
  cluster_version = var.kubernetes_version
  subnet_ids         = var.subnet_ids
  create_cloudwatch_log_group            =  false
  cloudwatch_log_group_retention_in_days =  1
  #create = true

  enable_irsa = true
  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = var.jenkins_role_arn
      username = var.jenkins_role_name
      groups   = ["system:masters"]
    },
  ]
  
  tags = {
    Name = "eks-cluster-${var.project_name}"
    env = var.tag_enviroment
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
    Purpose   = "Kubernetes"
    App_name  = var.app_name
    Task      = var.app_task
    Owner     = var.app_owner
    CreatedBy = var.created_by
  }
  vpc_id = var.vpc_id
  eks_managed_node_group_defaults = {
      ami_type               = "AL2_x86_64"
      instance_types         = ["t2.medium"]
      vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }

  eks_managed_node_groups = {
    
    eks_group_1 = {
      min_size     = 2
      max_size     = 6
      desired_size = 2
      instance_types = ["t3.medium"]
    }

    eks_group_2 = {
      min_size     = 2
      max_size     = 6
      desired_size = 2
      instance_types = ["t3.large"]

    }
  }
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster" "eks" {
  name = module.eks.cluster_id
}
data "aws_caller_identity" "current" {}

module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 4.7.0"
  create_role                   = true
  role_name                     = "opsschool-role"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.k8s_service_account_namespace}:${local.k8s_service_account_name}"]
  depends_on = [module.eks]
}

provider "kubernetes" {
  config_path            = "~/.kube/config"
  config_context         = "arn:aws:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${var.eks_cluster_name}"
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks.token
}