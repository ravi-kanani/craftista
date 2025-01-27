resource "kubernetes_namespace" "craftista" {
  metadata {
    name = var.craftista_namespace
  }
}

locals {
  app_selector_key   = "app"
  app_selector_value = "frontend"
}

resource "kubernetes_deployment" "craftista-frontend" {
  depends_on = [kubernetes_namespace.craftista]
  metadata {
    name      = "craftista-frontend"
    namespace = var.craftista_namespace
    labels = {
      "app" = "frontend-deployment"
    }
  }
  spec {
    selector {
      match_labels = {
        (local.app_selector_key) = local.app_selector_value
      }
    }
    template {
      metadata {
        name      = "craftista-frontend"
        namespace = var.craftista_namespace
        labels = {
          (local.app_selector_key) = local.app_selector_value
        }
      }
      spec {
        container {
          name  = "frontend-container"
          image = "localhost:32000/craftista-frontend"
          port {
            container_port = 3000
          }
        }
      }
    }
    replicas = 3
  }
}

resource "kubernetes_service" "craftista-frontend-service" {
  depends_on = [kubernetes_deployment.craftista-frontend]
  metadata {
    name      = "frontend-service"
    namespace = var.craftista_namespace
    labels = {
      "app" = "frontend-service"
    }
  }
  spec {
    selector = {
      (local.app_selector_key) = local.app_selector_value
    }
    port {
      port        = 80
      target_port = 3000
    }
  }
}

resource "kubernetes_ingress_v1" "craftista-ingress" {
  depends_on = [kubernetes_service.craftista-frontend-service]
  metadata {
    name      = "craftista-ingress"
    namespace = var.craftista_namespace
  }
  spec {
    rule {
      http {
        path {
          path = "/"
          backend {
            service {
              name = kubernetes_service.craftista-frontend-service.metadata.0.name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
