terraform {
  required_version = ">= 1.6"

  required_providers {
    vcfa = {
      source  = "vmware/vcfa"
      version = "~> 1.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.30"
    }
  }
}
