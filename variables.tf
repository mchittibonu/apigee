variable "gcp_project_id" {
  type        = string
  description = "Google Cloud Project ID for Apigee Control Plane"
}

variable "gcp_region" {
  type        = string
  default     = "us-central1"
  description = "GCP region"
}

variable "azure_location" {
  type        = string
  default     = "eastus"
  description = "Azure region for AKS runtime cluster"
}

variable "apigee_env_name" {
  type        = string
  default     = "prod-env"
  description = "Apigee Environment Name"
}
