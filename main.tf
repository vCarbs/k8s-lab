###############################################
# Kubernetes Provider Configuration
###############################################
provider "kubernetes" {
  config_context_cluster = var.kubernetes_cluster_name
}

module "namespaces" {
  source = "./modules/namespaces"
}

module "rbac" {
  source = "./modules/rbac"
}

module "metal_lb" {
  source = "./modules/metal_lb"
}

module "traefik" {
  source = "./modules/traefik"
}