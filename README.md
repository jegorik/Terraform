@@ -1,39 +1,108 @@
 # EKS Cluster with Atlantis Infrastructure
 
-This project provides infrastructure as code (Infrastructure as Code) for deploying an Amazon Elastic Kubernetes Service cluster with Atlantis for GitOps workflow management.
+This project provides Infrastructure as Code (IaC) for deploying an Amazon Elastic Kubernetes Service (EKS) cluster with Atlantis for GitOps workflow management.
 
 ## Architecture Overview
 
 The infrastructure consists of:
 
+- Amazon EKS Cluster (v1.32)
+- VPC with public and private subnets
+- Managed Node Groups for worker nodes
+- Atlantis deployment for GitOps
+- IAM roles and policies for cluster access
+
+```mermaid
+graph TD
+    A[VPC] --> B[Public Subnets]
+    A --> C[Private Subnets]
+    B --> D[NAT Gateway]
+    C --> E[EKS Cluster]
+    E --> F[Managed Node Groups]
+    E --> G[Atlantis Deployment]
+```
+
 ## Prerequisites
 
+Before deploying this infrastructure, ensure you have:
+
+- AWS CLI installed and configured
+- Terraform v1.3 or later
+- kubectl installed
+- GitHub account with repository access
+- Required AWS permissions:
+  - EKS cluster creation
+  - VPC management
+  - IAM role creation
 
 ## Installation
 
 1. Clone the repository
 2. Configure variables in `terraform.tfvars`
 3. Initialize Terraform:
+   ```bash
+   terraform init
+   terraform plan
+   terraform apply
+   ```
 
 ## Configuration
 
 ### Required Variables
-- `region`: AWS region for deployment
-- `vpc_cidr`: CIDR block for VPC
-- `cluster_name`: Name of the EKS cluster
-- `worker_type`: Instance types for worker nodes
+| Variable | Description | Type | Default |
+|----------|-------------|------|---------|
+| `region` | AWS region for deployment | string | - |
+| `vpc_cidr` | CIDR block for VPC | string | - |
+| `cluster_name` | Name of the EKS cluster | string | - |
+| `worker_type` | Instance types for worker nodes | list(string) | - |
 
 ### Optional Variables
-- `private_cidr`: CIDR blocks for private subnets
-- `public_cidr`: CIDR blocks for public subnets
+| Variable | Description | Type | Default |
+|----------|-------------|------|---------|
+| `private_cidr` | CIDR blocks for private subnets | list(string) | ["10.0.1.0/24", "10.0.2.0/24"] |
+| `public_cidr` | CIDR blocks for public subnets | list(string) | ["10.0.4.0/24", "10.0.5.0/24"] |
 
 ## Atlantis Setup
 
 1. Update `atlantis.yaml` with your GitHub credentials
 2. Configure webhook in your GitHub repository
 3. Access Atlantis UI through the load balancer endpoint
+
+## Operations Guide
+
+### Monitoring
+- EKS Control Plane logs are enabled for:
+  - API server
+  - Audit
+  - Authenticator
+  - Controller manager
+  - Scheduler
+
+### Scaling
+- Node groups are configured with auto-scaling:
+  - Min: 1
+  - Max: 2
+  - Desired: 1
+
+## Troubleshooting
+
+Common issues and solutions:
+
+1. Cluster Access Issues
+   ```bash
+   aws eks update-kubeconfig --name <cluster-name> --region <region>
+   ```
+
+2. Atlantis Connection Issues
+   - Verify GitHub webhook configuration
+   - Check Atlantis pod logs