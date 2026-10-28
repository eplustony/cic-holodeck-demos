# =============================================================================
# 1. IaC against VCF Automation: a new vSphere Namespace in default-project.
#    Same object as Project > Namespaces > New Namespace in the Org portal.
# =============================================================================
# Borrow the storage class from the existing namespace so nothing is guessed
data "vcfa_supervisor_namespace" "existing" {
  name         = var.existing_namespace
  project_name = var.project
}

resource "vcfa_supervisor_namespace" "demo" {
  name_prefix  = "tf-demo"
  project_name = var.project
  class_name   = var.namespace_class
  region_name  = var.region
  vpc_name     = var.vpc
  description  = "Created by Terraform (cic-holodeck-demos/terraform)"

  # The "small" class doesn't pin a storage class or zone, so set both here
  storage_classes_class_config_overrides {
    name  = tolist(data.vcfa_supervisor_namespace.existing.storage_classes)[0].name
    limit = var.storage_limit
  }

  # Zone
  zones_class_config_overrides {
    name               = var.zone
    cpu_limit          = var.zone_cpu_limit
    cpu_reservation    = "0M"
    memory_limit       = var.zone_memory_limit
    memory_reservation = "0Mi"
  }
}

# =============================================================================
# 2. Read the existing VKS cluster - nothing new is deployed.
# =============================================================================
data "vcfa_vks_cluster" "existing" {
  name = var.vks_cluster
  context = {
    project   = var.project
    namespace = var.existing_namespace
  }
}

# =============================================================================
# 3. Hand the app to GitOps: Terraform registers an Argo CD Application,
#    Argo CD deploys podinfo from Git onto acme-vks-01.
#    Terraform owns "where it runs"; Git owns "what runs".
# =============================================================================
resource "kubernetes_manifest" "argo_app" {
  provider = kubernetes.supervisor_ns

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = var.app_name
      namespace = var.existing_namespace
      labels = {
        "managed-by" = "terraform"
      }
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.git_repo
        path           = var.git_path
        targetRevision = "HEAD"
      }
      destination = {
        server    = var.argocd_destination_server
        namespace = var.app_name
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }
}
