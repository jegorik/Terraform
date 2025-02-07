resource "github_repository_webhook" "atlantis" {
  repository = var.github_repo

  configuration {
    url          = "http://${data.kubernetes_service.atlantis.status.0.load_balancer.0.ingress.0.hostname}/events"
    content_type = "json"
    secret       = var.github_webhook_secret
  }

  active = true
  events = ["pull_request", "push"]
}