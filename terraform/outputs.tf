output "new_namespace" {
  description = "Name VCFA generated for the new vSphere Namespace"
  value       = vcfa_supervisor_namespace.demo.name
}

output "new_namespace_ready" {
  value = vcfa_supervisor_namespace.demo.ready
}

output "vks_cluster" {
  value = data.vcfa_vks_cluster.existing.name
}

output "argo_application" {
  value = "${var.app_name} -> https://acme-argo.site-a.vcf.lab/applications/${var.existing_namespace}/${var.app_name}"
}
