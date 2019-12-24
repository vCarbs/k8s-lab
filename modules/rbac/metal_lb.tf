#######################################
# Metal LB RBAC 
#######################################

resource "kubernetes_service_account" "controller" {
  metadata {
    name      = "controller"
    namespace = "metallb-system"

    labels = {
      app = "metallb"
    }
  }

  automount_service_account_token = "true"
}

resource "kubernetes_service_account" "speaker" {
  metadata {
    name      = "speaker"
    namespace = "metallb-system"

    labels = {
      app = "metallb"
    }
  }

  automount_service_account_token = "true"
}

resource "kubernetes_cluster_role" "metallb_system_controller" {
  metadata {
    name = "metallb-system:controller"

    labels = {
      app = "metallb"
    }
  }

  rule {
    verbs      = ["get", "list", "watch", "update"]
    api_groups = [""]
    resources  = ["services"]
  }

  rule {
    verbs      = ["update"]
    api_groups = [""]
    resources  = ["services/status"]
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }
}

resource "kubernetes_cluster_role" "metallb_system_speaker" {
  metadata {
    name = "metallb-system:speaker"

    labels = {
      app = "metallb"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["services", "endpoints", "nodes"]
  }

  rule {
    verbs      = ["create", "patch"]
    api_groups = [""]
    resources  = ["events"]
  }

  rule {
    verbs          = ["use"]
    api_groups     = ["extensions"]
    resources      = ["podsecuritypolicies"]
    resource_names = ["speaker"]
  }
}

resource "kubernetes_role" "config_watcher" {
  metadata {
    name      = "config-watcher"
    namespace = "metallb-system"

    labels = {
      app = "metallb"
    }
  }

  rule {
    verbs      = ["get", "list", "watch"]
    api_groups = [""]
    resources  = ["configmaps"]
  }
}

resource "kubernetes_cluster_role_binding" "metallb_system_controller" {
  metadata {
    name = "metallb-system:controller"

    labels = {
      app = "metallb"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "controller"
    namespace = "metallb-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "metallb-system:controller"
  }
}

resource "kubernetes_cluster_role_binding" "metallb_system_speaker" {
  metadata {
    name = "metallb-system:speaker"

    labels = {
      app = "metallb"
    }
  }

  subject {
    kind      = "ServiceAccount"
    name      = "speaker"
    namespace = "metallb-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "metallb-system:speaker"
  }
}

resource "kubernetes_role_binding" "config_watcher" {
  metadata {
    name      = "config-watcher"
    namespace = "metallb-system"

    labels = {
      app = "metallb"
    }
  }

  subject {
    kind = "ServiceAccount"
    name = "controller"
  }

  subject {
    kind = "ServiceAccount"
    name = "speaker"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "config-watcher"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f rb_config_watcher.yml"
  }
}