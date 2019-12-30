## Overview

These Terraform modules will deploy the following into a Kubernetes cluster
1. Metal LB
2. Traefik 
3. Kubernetes Dashboard

## Requirements:

- Terraform `brew install terraform`
- Terragrunt `brew install terragrunt`

## Usage

1. Clone this git repo `https://github.com/vCarbs/k8s-lab.git`
2. Edit the following files: `terraform.tfvars` and `modules/metal_lb/terraform.tfvars`
3. Run `terraform init`
4. Run `terragrunt plan-all` 
5. Run `terragrunt apply-all`
6. View the `traefik_dashboard = https://1.1.1.1:8080` and `dashboard_ip_address = https://1.1.1.1` outputs for web access
