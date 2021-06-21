terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.56.0"
    }
  }
  experiments = [module_variable_optional_attrs]
}
