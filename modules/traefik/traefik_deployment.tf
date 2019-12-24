resource "kubernetes_deployment" "traefik_ingress_controller" {
  metadata {
    name      = "traefik-ingress-controller"
    namespace = "default"

    labels = {
      k8s-app = "traefik-ingress-lb"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        k8s-app = "traefik-ingress-lb"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = "traefik-ingress-lb"

          name = "traefik-ingress-lb"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = "traefik-https-cfg"
          }
        }

        container {
          name  = "traefik-ingress-lb"
          image = "traefik:v1.7-alpine"
          args  = ["--api", "--configfile=/config/traefik.toml"]

          port {
            name           = "http"
            container_port = 80
          }

          port {
            name           = "admin"
            container_port = 8080
          }

          volume_mount {
            name       = "config"
            mount_path = "/config"
          }
        }

        termination_grace_period_seconds = 60
        service_account_name             = "traefik-ingress-controller"
        automount_service_account_token  = true
      }
    }
  }
}

resource "kubernetes_service" "traefik_ingress_service" {
  metadata {
    name      = "traefik-ingress-service"
    namespace = "default"
  }

  spec {
    port {
      name     = "https"
      protocol = "TCP"
      port     = 443
    }

    port {
      name     = "http"
      protocol = "TCP"
      port     = 80
    }

    port {
      name     = "admin"
      protocol = "TCP"
      port     = 8080
    }

    selector = {
      k8s-app = "traefik-ingress-lb"
    }

    type = "LoadBalancer"
  }
}

output "traefik_dashboard" {
  value = "https://${kubernetes_service.traefik_ingress_service.load_balancer_ingress[0].ip}:8080"
}
