# Get available AWS Availability Zones
# Filter only zones that don't require explicit opt-in
# This ensures we can deploy resources in standard regions
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  cluster_name = "eks-cluster"
}

# VPC Configuration
# Creates a VPC with public and private subnets
# Enables NAT Gateway for private subnet internet access
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = var.vpc_name

  cidr = var.vpc_cidr
  azs  = slice(data.aws_availability_zones.available.names, 0, 2)

  private_subnets = var.private_cidr
  public_subnets  = var.public_cidr

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

}
