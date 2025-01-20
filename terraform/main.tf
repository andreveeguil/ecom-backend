terraform {
  backend "gcs" {
    bucket = " test-terraform-ai"
    prefix = "terraform/state"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "ecom_backend" {
  metadata {
    name = "ecom-backend"
    labels = {
      app = "ecom-backend"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "ecom-backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "ecom-backend"
        }
      }

      spec {
        container {
          image = "gcr.io/${var.project_id}/ecom-backend:latest"
          name  = "ecom-backend"

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}
