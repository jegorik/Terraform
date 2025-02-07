variable "aws_region" {
  default = "eu-central-1"
}

variable "github_owner" {
  description = "GitHub organization or user name"
}

variable "github_repo" {
  description = "GitHub repository name"
}

variable "github_user" {
  description = "GitHub username for Atlantis"
}

variable "github_token" {
  description = "GitHub personal access token"
  sensitive   = true
}

variable "github_webhook_secret" {
  description = "Webhook secret for Atlantis"
  sensitive   = true
}