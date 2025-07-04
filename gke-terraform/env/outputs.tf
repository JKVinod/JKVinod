output "gke_endpoint" {
  value = module.gke.endpoint
}

output "argocd_server_url" {
  value = helm_release.argocd.status[0].url
}
