resource "azurerm_resource_group" "apigee_rg" {
  name     = "rg-apigee-hybrid-azure"
  location = var.azure_location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-apigee-aks"
  address_space       = ["10.100.0.0/16"]
  location            = azurerm_resource_group.apigee_rg.location
  resource_group_name = azurerm_resource_group.apigee_rg.name
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "subnet-aks"
  resource_group_name  = azurerm_resource_group.apigee_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.100.1.0/24"]
}

resource "azurerm_kubernetes_cluster" "apigee_aks" {
  name                = "apigee-hybrid-aks"
  location            = azurerm_resource_group.apigee_rg.location
  resource_group_name = azurerm_resource_group.apigee_rg.name
  dns_prefix          = "apigee-hybrid"

  default_node_pool {
    name       = "systempool"
    node_count = 2
    vm_size    = "Standard_D4s_v3"
    subnet_id  = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "apigee_data" {
  name                  = "apigeedata"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.apigee_aks.id
  vm_size               = "Standard_D8s_v3"
  node_count            = 3
  subnet_id             = azurerm_subnet.aks_subnet.id
}

resource "azurerm_kubernetes_cluster_node_pool" "apigee_runtime" {
  name                  = "apigeerun"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.apigee_aks.id
  vm_size               = "Standard_D4s_v3"
  node_count            = 2
  subnet_id             = azurerm_subnet.aks_subnet.id
}

resource "google_apigee_organization" "apigee_org" {
  analytics_region   = var.gcp_region
  project_id         = var.gcp_project_id
  runtime_type       = "HYBRID"
  authorized_network = "default"
}

resource "google_apigee_environment" "apigee_env" {
  org_id          = google_apigee_organization.apigee_org.id
  name            = var.apigee_env_name
  description     = "Apigee Environment running on Azure AKS Hybrid"
  display_name    = var.apigee_env_name
  deployment_type = "HYBRID"
}
