resource "azurecaf_name" "aks" {
  name          = var.project
  resource_type = "azurerm_kubernetes_cluster"
  suffixes      = [var.stage]
}

# create AKS
resource "azurerm_kubernetes_cluster" "aks" {
  for_each               = local.aks_cluster
  name                   = "${azurecaf_name.aks.result}-${each.key}"
  location               = var.location
  resource_group_name    = azurerm_resource_group.core.name
  dns_prefix             = "${azurecaf_name.aks.result}-${each.key}"
  kubernetes_version     = "1.27.3"
  local_account_disabled = "true"
  tags                   = local.common_tags

  azure_active_directory_role_based_access_control {
    managed                = true
    tenant_id              = data.azurerm_client_config.current.tenant_id
    admin_group_object_ids = ["429bfc0b-dac5-4dd8-862a-831985f20e4d"]
    azure_rbac_enabled     = true
  }

  network_profile {
    network_plugin = "none"
    #pod_cidrs      = [each.value.pod_cidr]
    service_cidr   = each.value.service_cidr
    dns_service_ip = each.value.dns_service_ip
  }

  default_node_pool {
    name           = "nodepool1"
    node_count     = 2
    vm_size        = "Standard_D2s_v3"
    vnet_subnet_id = azurerm_subnet.aks[each.key].id
  }

  identity {
    type = "SystemAssigned"
  }
}

# Role assignment to be able to manage the virtual network
resource "azurerm_role_assignment" "aks_vnet_contributor" {
  for_each                         = local.aks_cluster
  scope                            = azurerm_resource_group.core.id
  role_definition_name             = "Network Contributor"
  principal_id                     = azurerm_kubernetes_cluster.aks[each.key].identity[0].principal_id
  skip_service_principal_aad_check = true
}
