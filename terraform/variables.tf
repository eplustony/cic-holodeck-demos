# --- VCF Automation tenant login -------------------------------------------
# The API token is NOT set here: export it before running Terraform
#   export VCFA_API_TOKEN='<token from the Org portal: user menu > API Tokens>'

variable "vcfa_url" {
  description = "VCF Automation endpoint"
  type        = string
  default     = "https://auto-a.site-a.vcf.lab"
}

variable "org" {
  description = "Tenant (All Apps) organization name - case sensitive"
  type        = string
  default     = "Acme-West-A"
}

variable "allow_unverified_ssl" {
  description = "Lab uses self-signed certs; set false once VCFA has a trusted cert"
  type        = bool
  default     = true
}

# --- Where things live ------------------------------------------------------

variable "project" {
  type    = string
  default = "default-project"
}

variable "region" {
  type    = string
  default = "us-west-a"
}

variable "vpc" {
  type    = string
  default = "default-us-west-a"
}

variable "zone" {
  description = "vSphere Zone for the new namespace (Supervisor > Zones)"
  type        = string
  default     = "zone-mgmt-a"
}

variable "zone_cpu_limit" {
  description = "CPU limit for the new namespace in that zone (M = MHz)"
  type        = string
  default     = "2000M"
}

variable "zone_memory_limit" {
  description = "Memory limit for the new namespace in that zone"
  type        = string
  default     = "4Gi"
}

variable "storage_limit" {
  description = "Storage limit for the new namespace (Mi, Gi or Ti)"
  type        = string
  default     = "10Gi"
}

variable "namespace_class" {
  description = "Namespace class to build the new namespace from (Manage & Govern > Namespace Class)"
  type        = string
  default     = "small"
}

# Existing objects the demo reuses (nothing new is built for these)
variable "existing_namespace" {
  description = "vSphere Namespace that hosts acme-vks-01 and the acme-argo instance"
  type        = string
  default     = "cic01-vcf01-9tqq2"
}

variable "vks_cluster" {
  type    = string
  default = "acme-vks-01"
}

variable "argocd_destination_server" {
  description = "acme-vks-01 API URL exactly as listed in Argo CD > Settings > Clusters"
  type        = string
  default     = "https://10.1.8.3:6443"
}

# --- The app Terraform hands to Argo CD -------------------------------------

variable "git_repo" {
  type    = string
  default = "https://github.com/eplustony/cic-holodeck-demos"
}

variable "git_path" {
  type    = string
  default = "podinfo"
}

variable "app_name" {
  description = "Argo CD Application name and target Kubernetes namespace"
  type        = string
  default     = "tf-podinfo"
}
