locals {
  voting_app_selector_key   = "app"
  voting_app_selector_value = "voting"
}

resource "kubernetes_deployment" "craftista-voting" {
  depends_on = [kubernetes_namespace.craftista]
  metadata {
    name      = "craftista-voting"
    namespace = var.craftista_namespace
    labels = {
      "app" = "voting-deployment"
    }
  }
  spec {
    selector {
      match_labels = {
        (local.voting_app_selector_key) = local.voting_app_selector_value
      }
    }
    template {
      metadata {
        name      = "craftista-voting"
        namespace = var.craftista_namespace
        labels = {
          (local.voting_app_selector_key) = local.voting_app_selector_value
        }
      }
      spec {
        container {
          name  = "voting-container"
          image = "localhost:32000/craftista-voting"
          port {
            container_port = 5000
          }
        }
      }
    }
    replicas = 1
  }
}

resource "kubernetes_service" "craftista-voting-service" {
  depends_on = [kubernetes_deployment.craftista-voting]
  metadata {
    name      = "voting"
    namespace = var.craftista_namespace
    labels = {
      "app" = "voting-service"
    }
  }
  spec {
    selector = {
      (local.voting_app_selector_key) = local.voting_app_selector_value
    }
    port {
      port        = 8080
      target_port = 8080
    }
  }
}
