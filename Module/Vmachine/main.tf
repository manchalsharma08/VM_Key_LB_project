resource "azurerm_public_ip" "pip3" {
  for_each = var.monika_lb
  name                = each.value.name_pip
  resource_group_name = each.value.name_rg
  location            = each.value.location
  allocation_method   = "Static"

}

resource "azurerm_network_interface" "nic" {
    for_each = var.monika_lb
  name                = each.value.name_nic
  location            = each.value.location
  resource_group_name = each.value.name_rg

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.snet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip3[each.key].id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
    for_each = var.monika_lb
  name                = each.value.name_vm
  resource_group_name = each.value.name_rg
  location            = each.value.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password = data.azurerm_key_vault_secret.vm-password.value
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id,
  ]

  

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}