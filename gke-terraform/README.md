# 🚀 GCP GKE Cluster with Terraform + GitOps Ready (ArgoCD)

[![Terraform Version](https://img.shields.io/badge/Terraform-%3E=1.2-blue.svg)](https://www.terraform.io/downloads)
[![GKE](https://img.shields.io/badge/GKE-Private_Cluster-green.svg)](https://cloud.google.com/kubernetes-engine/docs/how-to/private-clusters)
[![ArgoCD](https://img.shields.io/badge/GitOps-ArgoCD-informational)](https://argo-cd.readthedocs.io/)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

This project provisions a **production-ready, secure, and GitOps-enabled Kubernetes platform** on **Google Cloud Platform (GCP)** using **Terraform**. It deploys a private **GKE (Google Kubernetes Engine)** cluster, foundational networking, and installs **ArgoCD via Helm** for continuous delivery.

---

## 🧭 Features

- ✅ Private GKE cluster with restricted access and no public node IPs
- ✅ Custom VPC and subnets (public/private separation)
- ✅ IAM-scoped RBAC roles for admin access
- ✅ Terraform remote state using GCS backend
- ✅ Modular design with reusable network and GKE modules
- ✅ GitOps-ready using Helm-based **ArgoCD** deployment
- ✅ ArgoCD exposed via LoadBalancer with TLS-ready configuration

---


---

## ⚙️ Prerequisites

- [Terraform ≥ 1.2](https://www.terraform.io/downloads)
- [GCP CLI (`gcloud`)](https://cloud.google.com/sdk/docs/install)
- An existing **GCS bucket** for Terraform state
- IAM permissions to create:
  - GKE clusters
  - VPC & Subnets
  - Service Accounts
  - IAM roles

---

## 📦 Usage

###  Clone the Repo

```bash
git clone https://github.com/your-org/gke-terraform.git
cd gke-terraform


🎯 GitOps with ArgoCD


ArgoCD is deployed via Helm after the cluster is created.

Namespace: argocd

Access: via GKE LoadBalancer IP

Customize: See helm_release.argocd in main.tf to override values

Login:

bash

kubectl -n argocd get svc argocd-server
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

