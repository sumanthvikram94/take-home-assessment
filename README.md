# Hiive DevOps Take-Home — Terraform → AWS EKS → Containerized Service

This repository provisions a complete AWS environment using Terraform and deploys a simple containerized service to an Amazon EKS Kubernetes cluster.
The service is exposed publicly through an AWS Application Load Balancer (ALB) created by the AWS Load Balancer Controller.

The solution includes all required ancillary infrastructure such as VPC networking, security, IAM, and Kubernetes resources.

---

## Architecture Overview

**Infrastructure**
- AWS VPC with public and private subnets across multiple AZs
- NAT Gateway for outbound access from private subnets
- Amazon EKS cluster with managed node group
- IAM Roles for Service Accounts (IRSA)

**Kubernetes**
- Namespace
- Deployment (NGINX)
- Service (NodePort)
- Ingress (ALB via AWS Load Balancer Controller)

**Traffic Flow**
Internet → ALB → Kubernetes Ingress → Service → Pod

---

## Prerequisites

### Tools
- Terraform >= 1.5
- AWS CLI v2
- kubectl
- Helm (optional)

### AWS Credentials
Verify AWS credentials:

```bash
aws sts get-caller-identity
```

---

## Repository Structure

```
.
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── lbc-iam-policy.json
└── k8s/
    ├── app.tf
    └── variables.tf
```

---

## Configuration

Default values:
- Region: us-east-1
- Kubernetes version: 1.29
- App image: nginx:1.27
- Replicas: 2

---

## Deployment Steps

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Deploy Infrastructure

```bash
terraform apply -target=module.vpc -target=module.eks -auto-approve
```

### 3. Configure kubectl

```bash
aws eks update-kubeconfig --region us-east-1 --name hiive-takehome-eks
kubectl get nodes
```

### 4. Deploy Application and Controller

```bash
terraform apply -auto-approve
```

### 5. Verify

```bash
kubectl -n kube-system get pods | grep load-balancer
kubectl -n demo get deploy,svc,ingress
```

### 6. Access Application

```bash
kubectl -n demo get ingress demo-nginx-ingress -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

Open the URL in a browser to see the NGINX welcome page.

---

## Cleanup

```bash
terraform destroy -auto-approve
```

---

## Key Design Decisions

- Community Terraform modules are used to reduce boilerplate while following AWS best practices.
- Kubernetes resources are isolated in a separate module for clean separation of concerns.
- IRSA is used for the AWS Load Balancer Controller to enforce least-privilege access.
- Ingress is used to provision a real ALB for easy verification.

---

## Submission Proof (Optional)

Include one of the following:
- Screenshot of the NGINX page via ALB
- Output of `kubectl -n demo get ingress demo-nginx-ingress`
- The ALB hostname as a service link
