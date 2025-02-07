resource "aws_iam_role" "eks_admin" {
  name = "eks-admin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role" "eks_read_only" {
  name = "eks-read-only"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "kubernetes_config_map" "aws_auth" {
  depends_on = [
    module.eks
  ]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<-EOT
      - rolearn: ${module.eks.eks_managed_node_groups["workers"].iam_role_arn}
        username: system:node:{{EC2PrivateDNSName}}
        groups:
          - system:bootstrappers
          - system:nodes
      - rolearn: ${aws_iam_role.eks_admin.arn}
        username: eks-admin
        groups:
          - system:masters
      - rolearn: ${aws_iam_role.eks_read_only.arn}
        username: eks-read-only
        groups:
          - view
    EOT
  }
}

data "aws_caller_identity" "current" {}