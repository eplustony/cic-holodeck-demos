# VCF Automation, logged in to the tenant org with an API token (VCFA_API_TOKEN)
provider "vcfa" {
  url                  = var.vcfa_url
  org                  = var.org
  auth_type            = "api_token"
  allow_unverified_ssl = var.allow_unverified_ssl
}

# Kubernetes API of the existing vSphere Namespace on the Supervisor.
# acme-argo runs here, so its Application objects are created here too.
data "vcfa_kubeconfig" "argo_ns" {
  project_name              = var.project
  supervisor_namespace_name = var.existing_namespace
}

provider "kubernetes" {
  alias    = "supervisor_ns"
  host     = data.vcfa_kubeconfig.argo_ns.host
  insecure = data.vcfa_kubeconfig.argo_ns.insecure_skip_tls_verify
  token    = data.vcfa_kubeconfig.argo_ns.token
}
