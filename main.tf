###############################################
# Kubernetes Provider Configuration
###############################################
provider "kubernetes" {
  config_context_cluster = var.config_context_cluster
}

module "namespaces" {
  source = "./modules/namespaces"
}

module "rbac" {
  source = "./modules/rbac"
}

module "metal_lb" {
  source = "./modules/metal_lb"

  metalip = var.metalip
}

module "traefik" {
  source = "./modules/traefik"
}
