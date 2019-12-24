resource "kubernetes_daemonset" "speaker" {
  metadata {
    name      = "speaker"
    namespace = "metallb-system"

    labels = {
      app = "metallb"

      component = "speaker"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "metallb"

        component = "speaker"
      }
    }

    template {
      metadata {
        labels = {
          app = "metallb"

          component = "speaker"
        }

        annotations = {
          "prometheus.io/port" = "7472"

          "prometheus.io/scrape" = "true"
        }
      }

      spec {
        container {
          name  = "speaker"
          image = "metallb/speaker:v0.8.2"
          args  = ["--port=7472", "--config=config"]

          port {
            name           = "monitoring"
            container_port = 7472
          }

          env {
            name = "METALLB_NODE_NAME"

            value_from {
              field_ref {
                field_path = "spec.nodeName"
              }
            }
          }

          env {
            name = "METALLB_HOST"

            value_from {
              field_ref {
                field_path = "status.hostIP"
              }
            }
          }

          resources {
            limits {
              cpu    = "100m"
              memory = "100Mi"
            }
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            read_only_root_filesystem = true
            capabilities {
              add = ["NET_ADMIN", "NET_RAW", "SYS_ADMIN"]
            }
          }
        }

        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }

        service_account_name            = "speaker"
        host_network                    = true
        automount_service_account_token = "true"

        toleration {
          key    = "node-role.kubernetes.io/master"
          effect = "NoSchedule"
        }
      }
    }
  }
}

resource "kubernetes_deployment" "controller" {
  metadata {
    name      = "controller"
    namespace = "metallb-system"

    labels = {
      app = "metallb"

      component = "controller"
    }
  }

  spec {
    selector {
      match_labels = {
        app = "metallb"

        component = "controller"
      }
    }

    template {
      metadata {
        labels = {
          app = "metallb"

          component = "controller"
        }

        annotations = {
          "prometheus.io/port" = "7472"

          "prometheus.io/scrape" = "true"
        }
      }

      spec {
        container {
          name  = "controller"
          image = "metallb/controller:v0.8.2"
          args  = ["--port=7472", "--config=config"]

          port {
            name           = "monitoring"
            container_port = 7472
          }

          resources {
            limits {
              cpu    = "100m"
              memory = "100Mi"
            }
          }

          image_pull_policy = "IfNotPresent"

          security_context {
            read_only_root_filesystem = true
          }
        }

        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }

        service_account_name            = "controller"
        automount_service_account_token = "true"

        security_context {
          run_as_user     = 65534
          run_as_non_root = true
        }
      }
    }

    revision_history_limit = 3
  }
}

