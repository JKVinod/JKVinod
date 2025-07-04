variable "project_id" { type = string }
variable "region"     { type = string, default = "us-central1" }
variable "state_bucket" { type = string }
variable "state_prefix" { type = string }
variable "cluster_name" { type = string, default = "gke-cluster" }

# Network variables
variable "vpc_cidr"        { type = string, default = "10.0.0.0/16" }
variable "public_subnet_cidr"  { type = string, default = "10.0.1.0/24" }
variable "private_subnet_cidr" { type = string, default = "10.0.2.0/24" }

# GKE nodepool
variable "node_count"     { type = number, default = 3 }
variable "machine_type"   { type = string, default = "e2-medium" }
