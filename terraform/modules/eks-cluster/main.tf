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
  ingress {
    from_port = 9090
    to_port   = 9090
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8600
    to_port   = 8600
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8300
    to_port   = 8300
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8500
    to_port   = 8500
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8301
    to_port   = 8301
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8302
    to_port   = 8302
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 53
    to_port   = 53
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 9100
    to_port   = 9100
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 9153
    to_port   = 9153
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 9091
    to_port   = 9091
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # ingress {
  #   from_port = 21000
  #   to_port   = 21000
  #   protocol  = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  # ingress {
  #   from_port = 21255
  #   to_port   = 21255
  #   protocol  = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
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
  }

  eks_managed_node_groups = {
    
    eks_group_1 = {
      min_size     = 2
      max_size     = 6
      desired_size = 2
      instance_types = ["t3.medium"]
      vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
    }

    eks_group_2 = {
      min_size     = 2
      max_size     = 6
      desired_size = 2
      instance_types = ["t3.large"]
      vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]

    }
  }
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 0
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
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