variable "config_context_cluster" {
  description = "This is the name of the kubernetes cluster you created. Use the 'kubectl cluster view' command to get this if you are unsure."
}

variable "metalip" {
  description = "IP address block for Metal LB" 
}
