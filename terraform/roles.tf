## Role for jenkins
resource "aws_iam_role" "jenkins-role" {
  name = "project-jenkins-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_policy" "jenkins-policy" {
  name        = "project-jenkins-policy"
  description = "this police will be used for jenkins"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        },
        {
            "Action": "eks:*",
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "jenkins-policy-attach" {
  role       = aws_iam_role.jenkins-role.name
  policy_arn = aws_iam_policy.jenkins-policy.arn
}
resource "aws_iam_instance_profile" "jenkins-role" {
  name  = "project-jenkins-role-profile"
  role = aws_iam_role.jenkins-role.name
}

## Role for ansible

resource "aws_iam_role" "ansible-role" {
  name = "project-ansible-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_policy" "ansible-policy" {
  name        = "project-ansible-policy"
  description = "this police will be used for ansible"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        }
    ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "ansible-policy-attach" {
  role       = aws_iam_role.ansible-role.name
  policy_arn = aws_iam_policy.ansible-policy.arn
}
resource "aws_iam_instance_profile" "ansible-role" {
  name  = "project-ansible-role-profile"
  role = aws_iam_role.ansible-role.name
}

## Role for consul
resource "aws_iam_role" "consul-role" {
  name = "project-consul-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "consul-policy" {
  name        = "project-consul-policy"
  description = "this police will be used for consul"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "ec2scheduled.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com",
                        "transitgateway.amazonaws.com"
                    ]
                }
            }
        }
    ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "consul-policy-attach" {
  role       = aws_iam_role.consul-role.name
  policy_arn = aws_iam_policy.consul-policy.arn
}
resource "aws_iam_instance_profile" "consul-role" {
  name  = "project-consul-role-profile"
  role = aws_iam_role.consul-role.name
}


## Role for EKS cluster

resource "aws_iam_role" "eks-role" {
  name = "project-eks-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "eks-policy" {
  name        = "project-eks-policy"
  description = "this police will be used for eks"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "ec2:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "cloudwatch:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:*",
            "Resource": "*"
        },
        {
            "Action": "eks:*",
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "autoscaling.amazonaws.com",
                        "ec2scheduled.amazonaws.com",
                        "elasticloadbalancing.amazonaws.com",
                        "spot.amazonaws.com",
                        "spotfleet.amazonaws.com",
                        "transitgateway.amazonaws.com"
                    ]
                }
            }
        }
    ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "eks-policy-attach" {
  role       = aws_iam_role.eks-role.name
  policy_arn = aws_iam_policy.eks-policy.arn
}
resource "aws_iam_instance_profile" "eks-role" {
  name  = "project-eks-role-profile"
  role = aws_iam_role.eks-role.name
}