resource "kubernetes_config_map" "config" {
  metadata {
    name      = "config"
    namespace = "metallb-system"
  }

  data = {
    config = "address-pools:\n- name: default\n  protocol: layer2\n  addresses:\n  - ${var.metalip}\n"
  }
}