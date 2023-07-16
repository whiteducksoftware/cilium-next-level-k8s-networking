locals {
  # Common tags to be assigned to all resources
  common_tags = {
    env       = var.stage
    managedBy = data.azurerm_client_config.current.client_id
    project   = var.project
  }
  # AKS Cluster
  aks_cluster = {
    "01" = {
      vnet_cidr      = "10.1.0.0/24"
      snet_cidr      = "10.1.0.0/24"
      pod_cidr       = "10.10.0.0/16"
      service_cidr   = "10.11.0.0/16"
      dns_service_ip = "10.11.0.10"
    }
    "02" = {
      vnet_cidr      = "10.2.0.0/24"
      snet_cidr      = "10.2.0.0/24"
      pod_cidr       = "10.20.0.0/16"
      service_cidr   = "10.11.0.0/16"
      dns_service_ip = "10.11.0.10"
    }
  }
}

# get current subscription
data "azurerm_subscription" "current" {
}

# get current client
data "azurerm_client_config" "current" {
}

resource "azurecaf_name" "rg" {
  name          = var.project
  resource_type = "azurerm_resource_group"
  suffixes      = [var.stage]
}

# Create Core Resource Group
resource "azurerm_resource_group" "core" {
  name     = azurecaf_name.rg.result
  location = var.location
  tags     = local.common_tags
}
