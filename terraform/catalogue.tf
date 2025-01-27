locals {
  catalogue_selector_key   = "app"
  catalogue_selector_value = "catalogue"
}

resource "kubernetes_deployment" "craftista-catalogue" {
  depends_on = [kubernetes_namespace.craftista]
  metadata {
    name      = "craftista-catalogue"
    namespace = var.craftista_namespace
    labels = {
      "app" = "catalogue-deployment"
    }
  }
  spec {
    selector {
      match_labels = {
        (local.catalogue_selector_key) = local.catalogue_selector_value
      }
    }
    template {
      metadata {
        name      = "craftista-catalogue"
        namespace = var.craftista_namespace
        labels = {
          (local.catalogue_selector_key) = local.catalogue_selector_value
        }
      }
      spec {
        container {
          name  = "catalogue-container"
          image = "localhost:32000/craftista-catalogue"
          port {
            container_port = 5000
          }
        }
      }
    }
    replicas = 1
  }
}

resource "kubernetes_service" "craftista-catalogue-service" {
  depends_on = [kubernetes_deployment.craftista-catalogue]
  metadata {
    name      = "catalogue"
    namespace = var.craftista_namespace
    labels = {
      "app" = "catalogue-service"
    }
  }
  spec {
    selector = {
      (local.catalogue_selector_key) = local.catalogue_selector_value
    }
    port {
      port        = 5000
      target_port = 5000
    }
  }
}
