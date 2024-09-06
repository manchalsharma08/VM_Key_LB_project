resource "azurerm_virtual_network" "vnet" {
    for_each = var.monika_lb
  name                = each.value.name_vnet
  location            = each.value.location
  resource_group_name = each.value.name_rg
  address_space       = each.value.address_space
}
  
  