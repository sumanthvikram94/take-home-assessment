output "cluster_name" {
  value = module.eks.cluster_name
}

output "region" {
  value = var.aws_region
}

output "configure_kubectl" {
  description = "Command to configure kubectl for this cluster"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ingress_hostname_hint" {
  value = "Run: kubectl -n demo get ingress demo-nginx-ingress -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"
}
