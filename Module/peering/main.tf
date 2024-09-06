data "azurerm_virtual_network" "pee" {
  name                = "monika-vnet"
  resource_group_name = "monika-rg"
}

data "azurerm_virtual_network" "pee1" {
  name                = "monika-vnet2"
  resource_group_name = "monika-rg"
}


resource "azurerm_virtual_network_peering" "example-1" {
  name                      = "peer1to2"
  resource_group_name       = "monika-rg"
  virtual_network_name      = "monika-vnet"
  remote_virtual_network_id = data.azurerm_virtual_network.pee1.id
}

resource "azurerm_virtual_network_peering" "example-2" {
  name                      = "peer2to1"
  resource_group_name       = "monika-rg"
  virtual_network_name      = "monika-vnet2"
  remote_virtual_network_id = data.azurerm_virtual_network.pee.id
}