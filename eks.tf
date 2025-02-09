# EKS Cluster Configuration
# Deploys an EKS cluster with managed node groups
# Enables cluster logging and encryption
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.33.1"

  cluster_name    = var.cluster_name
  cluster_version = "1.32"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = var.ami_type
  }

  # Worker Node Configuration
  # Defines the auto-scaling group for worker nodes
  eks_managed_node_groups = {
    group_default = {
      name = var.workers_group_name

      instance_types = var.worker_type

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }

  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}
