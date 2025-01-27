locals {
  catalogue_db_selector_key   = "app"
  catalogue_db_selector_value = "catalogue-db"
}
/*
resource "kubernetes_persistent_volume" "catalogue-db-volume" {
  metadata {
    name = "craftista-catalogue-db-volume"
  }
  spec {
    capacity = {
      storage = "50Mi"
    }
    storage_class_name = "microk8s-hostpath"
    access_modes       = ["ReadWriteMany"]
    persistent_volume_source {
      local {
        path = "/tmp/postgres/data"
      }
    }
    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key      = "kubernetes.io/hostname"
            operator = "In"
            values   = ["ravikanani"]
          }
        }
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "catalogue-db-volume-claim" {
  depends_on = [kubernetes_persistent_volume.catalogue-db-volume]
  metadata {
    name      = "catalogue-db-volume-claim"
    namespace = var.craftista_namespace
  }
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "50Mi"
      }
    }
    storage_class_name = "microk8s-hostpath"
    volume_name        = kubernetes_persistent_volume.catalogue-db-volume.metadata.0.name
  }
}
*/

resource "kubernetes_secret" "craftista-catalogue-db-secrets" {
  depends_on = [kubernetes_namespace.craftista]
  metadata {
    name      = "craftista-catalogue-db-secrets"
    namespace = var.craftista_namespace
  }
  data = {
    "POSTGRES_DB"       = "Y2F0YWxvZ3VlCg=="
    "POSTGRES_USER"     = "ZGV2b3BzCg=="
    "POSTGRES_PASSWORD" = "ZGV2b3BzCg=="
  }
}

resource "kubernetes_service" "caftista-catalogue-db-service" {
  depends_on = [kubernetes_namespace.craftista]
  metadata {
    name      = "catalogue-db"
    namespace = var.craftista_namespace
  }
  spec {
    selector = {
      (local.catalogue_db_selector_key) = local.catalogue_db_selector_value
    }
    port {
      port        = 5432
      target_port = 5432
    }
  }
}

resource "kubernetes_stateful_set" "craftista-catalogue-db" {
  depends_on = [kubernetes_namespace.craftista, kubernetes_secret.craftista-catalogue-db-secrets]
  metadata {
    name      = "craftista-catalogue-db"
    namespace = var.craftista_namespace
  }
  spec {
    service_name = kubernetes_service.caftista-catalogue-db-service.metadata.0.name
    replicas     = 1
    selector {
      match_labels = {
        (local.catalogue_db_selector_key) = local.catalogue_db_selector_value
      }
    }
    template {
      metadata {
        name      = "craftista-catalogue-db"
        namespace = var.craftista_namespace
        labels = {
          (local.catalogue_db_selector_key) = local.catalogue_db_selector_value
        }
      }
      spec {
        container {
          image = "postgres"
          name  = "catalogue-db-container"
          env_from {
            secret_ref {
              name = kubernetes_secret.craftista-catalogue-db-secrets.metadata.0.name
            }
          }
          volume_mount {
            name       = "db-data"
            mount_path = "/var/lib/postgresql/data"
          }
        }
        volume {
          name = "db-data"
          host_path {
            path = "/tmp/postgres/data"
          }
        }
      }
    }
  }
}
