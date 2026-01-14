variable "aws_region" {
  type        = string
  description = "AWS region to deploy into"
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "Base name prefix for resources"
  default     = "hiive-takehome"
}

variable "cluster_version" {
  type        = string
  description = "EKS Kubernetes version"
  default     = "1.29"
}

variable "node_instance_types" {
  type        = list(string)
  description = "Managed node group instance types"
  default     = ["t3.medium"]
}

variable "desired_size" {
  type        = number
  default     = 2
}
variable "min_size" {
  type        = number
  default     = 1
}
variable "max_size" {
  type        = number
  default     = 3
}

variable "app_image" {
  type        = string
  description = "Container image to deploy"
  default     = "nginx:1.27"
}

variable "app_replicas" {
  type        = number
  default     = 2
}

