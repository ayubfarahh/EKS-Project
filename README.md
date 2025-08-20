# AWS EKS Kuberbnetes Project with Terraform

This project provisions a secure, production grade Kubernetes platform on AWS to deploy and manage a containerised version of the classic 2048 game, all powered by Terraform, Helm, and GitHub Actions. 
It’s a showcase of cloud native architecture, GitOps automation, and modular infrastructure design.
fsdf

# Architecture Diagram
![alt text!](/img/EKS_ARCH.png)

## Features

- Lightweight, multi-stage Docker build for efficient containerisation
- Clearly seperated CI/CD workflows for plan, apply, and destroy stages
- Impleneted GitOps, Argo CD continuous sync & rollback from Git
- Security → IRSA least-privilege roles for in cluster controllers
- Integrated security scanning using Trivy during the DOcker image build process
- Pre-commit hooks utilising the shift left approach

## Local App Setup

Steps to Run Locally
### 1. Clone the Repo
```
git clone https://github.com/ayubfarahh/EKS-Project.git
cd EKS-Project
```

### 2. Start a Local Cluster
```
kind create cluster --name local-eks
```

### 3. Install NGINX Ingress Controller
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
```

### 4. Deploy the 2048 App
```
kubectl apply -f kubernetes/apps/2048.yaml
```