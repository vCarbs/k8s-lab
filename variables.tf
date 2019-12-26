variable "kubernetes_cluster_name" {
  description = "This is the name of the kubernetes cluster you created. Use the 'kubectl cluster view' command to get this if you are unsure."
  default = "ntnxk8s"
}