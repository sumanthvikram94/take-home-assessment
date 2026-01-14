variable "app_image" {
  type        = string
  description = "Container image to deploy"
}

variable "app_replicas" {
  type        = number
  description = "Number of replicas"
}

variable "depends_on_controller" {
  type        = any
  description = "Dependency placeholder to ensure controller is installed first"
}


