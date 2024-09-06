resource "azurerm_public_ip" "pip" {
    for_each = var.monika_lb
  name             = each.value.name_pip
  location            = each.value.location
  resource_group_name = each.value.name_rg
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
    for_each = var.monika_lb
  name                = each.value.name_bastion
  location            = each.value.location
  resource_group_name = each.value.name_rg

  ip_configuration {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.data-snet[each.key].id
    public_ip_address_id = azurerm_public_ip.pip[each.key].id
  }
}