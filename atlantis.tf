resource "helm_release" "atlantis" {
    depends_on = [
    module.eks,
    kubernetes_config_map.aws_auth
  ]

  name       = "atlantis"
  repository = "runatlantis"
  chart      = "atlantis"
  version    = "5.13.0"
  namespace        = "atlantis"
  create_namespace = true

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "github.user"
    value = var.github_user
  }

  set {
    name  = "github.token"
    value = var.github_token
  }

  set {
    name  = "github.secret"
    value = var.github_webhook_secret
  }

  set {
    name  = "repoWhitelist"
    value = "github.com/${var.github_owner}/${var.github_repo}"
  }
}

data "kubernetes_service" "atlantis" {
  metadata {
    name      = "atlantis"
    namespace = "atlantis"
  }
  depends_on = [helm_release.atlantis]
}