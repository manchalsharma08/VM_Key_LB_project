data "azurerm_subnet" "data-snet" {
    for_each = var.monika_lb
  name                 = each.value.name_snet
  virtual_network_name = each.value.name_vnet
  resource_group_name  = each.value.name_rg
}