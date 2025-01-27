locals {
  recommendation_app_selector_key   = "app"
  recommendation_app_selector_value = "recommendation"
}

resource "kubernetes_deployment" "craftista-recommendation" {
  depends_on = [kubernetes_namespace.craftista]
  metadata {
    name      = "craftista-recommendation"
    namespace = var.craftista_namespace
    labels = {
      "app" = "recommendation-deployment"
    }
  }
  spec {
    selector {
      match_labels = {
        (local.recommendation_app_selector_key) = local.recommendation_app_selector_value
      }
    }
    template {
      metadata {
        name      = "craftista-recommendation"
        namespace = var.craftista_namespace
        labels = {
          (local.recommendation_app_selector_key) = local.recommendation_app_selector_value
        }
      }
      spec {
        container {
          name  = "recommendation-container"
          image = "localhost:32000/craftista-recommendation"
          port {
            container_port = 5000
          }
        }
      }
    }
    replicas = 1
  }
}

resource "kubernetes_service" "craftista-recommendation-service" {
  depends_on = [kubernetes_deployment.craftista-recommendation]
  metadata {
    name      = "recommendation"
    namespace = var.craftista_namespace
    labels = {
      "app" = "recommendation-service"
    }
  }
  spec {
    selector = {
      (local.recommendation_app_selector_key) = local.recommendation_app_selector_value
    }
    port {
      port        = 8080
      target_port = 8080
    }
  }
}
