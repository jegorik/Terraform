variable "region" {
  description = "AWS region"
  type        = string
}

variable "kubernetes_namespace" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "worker_type" {
  type = list(string)
}

variable "ami_type" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "workers_group_name" {
  type = string
}

variable "private_cidr" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_cidr" {
  type = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24"]
}