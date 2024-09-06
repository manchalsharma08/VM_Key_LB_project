resource "azurerm_subnet" "snet" {
for_each = var.monika_lb

  name                 = each.value.name_snet
  resource_group_name  = each.value.name_rg
  virtual_network_name = each.value.name_vnet
  address_prefixes     = each.value.address_prefixes


}