module "vpc" {
  source              = "./modules/vpc"
  network_name        = "infra-vpc"
  region              = var.region
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
}

module "gke" {
  source          = "./modules/gke-cluster"
  project_id      = var.project_id
  region          = var.region
  cluster_name    = var.cluster_name
  vpc_id          = module.vpc.vpc_id
  private_subnet  = module.vpc.private_subnet
  node_count      = var.node_count
  machine_type    = var.machine_type
  admin_cidr      = "0.0.0.0/0"             # Adjust for production
  admins          = ["user:admin@example.com"]
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.3.7"

  namespace  = "argocd"
  create_namespace = true

  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}
