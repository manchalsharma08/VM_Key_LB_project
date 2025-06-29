resource "azurerm_resource_group" "rg" {
  for_each = var.monika_lb
  name     = each.value.name_rg
  location = each.value.location
}

resource "azurerm_virtual_network" "vnet" {
  for_each = var.monika_lb
  name                = each.value.name_vnet
  location            = each.value.location
  resource_group_name = each.value.name_rg
  address_space       = each.value.address_space
  depends_on = [ azurerm_resource_group.rg ]
}

resource "azurerm_subnet" "snet" {
  for_each = var.monika_lb
  name                 = each.value.name_snet
  resource_group_name  = each.value.name_rg
  virtual_network_name = each.value.name_vnet
  address_prefixes     = each.value.address_prefixes
  depends_on = [ azurerm_resource_group.rg, azurerm_virtual_network.vnet ]
}

output "subnet_ids" {
  value = {
    for key, subnet in azurerm_subnet.snet :
    key =>
     subnet.id
  }
  
  depends_on = [ azurerm_subnet.snet ]
}


