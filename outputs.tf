output "aks_get_credentials_command" {
  description = "Run this command to configure kubectl for your new Azure AKS cluster"
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.apigee_rg.name} --name ${azurerm_kubernetes_cluster.apigee_aks.name}"
}

output "apigee_organization_id" {
  description = "GCP Apigee Organization Resource ID"
  value       = google_apigee_organization.apigee_org.id
}
