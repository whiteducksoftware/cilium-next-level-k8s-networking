resource "azurecaf_name" "virtual_network" {
  name          = var.project
  resource_type = "azurerm_virtual_network"
  suffixes      = [var.stage]
}

resource "azurecaf_name" "subnet" {
  name          = var.project
  resource_type = "azurerm_subnet"
  suffixes      = [var.stage]
}

resource "azurecaf_name" "peering" {
  name          = var.project
  resource_type = "azurerm_virtual_network_peering"
  suffixes      = [var.stage]
}

# Hub Virtual Network
resource "azurerm_virtual_network" "core" {
  for_each            = local.aks_cluster
  name                = "${azurecaf_name.virtual_network.result}-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.core.name
  address_space       = ["${each.value.vnet_cidr}"]
  tags                = local.common_tags
}

# Spoke Subnet for Azure PaaS Services
resource "azurerm_subnet" "aks" {
  for_each             = local.aks_cluster
  name                 = "${azurecaf_name.subnet.result}-${each.key}"
  resource_group_name  = azurerm_resource_group.core.name
  virtual_network_name = azurerm_virtual_network.core[each.key].name
  address_prefixes     = ["${each.value.snet_cidr}"]
}

resource "azurerm_virtual_network_peering" "aks_vnet_01" {
  name                      = "${azurecaf_name.peering.result}-vnet-02"
  resource_group_name       = azurerm_resource_group.core.name
  virtual_network_name      = azurerm_virtual_network.core["01"].name
  remote_virtual_network_id = azurerm_virtual_network.core["02"].id
}

resource "azurerm_virtual_network_peering" "aks_vnet_02" {
  name                      = "${azurecaf_name.peering.result}-vnet-01"
  resource_group_name       = azurerm_resource_group.core.name
  virtual_network_name      = azurerm_virtual_network.core["02"].name
  remote_virtual_network_id = azurerm_virtual_network.core["01"].id
}
