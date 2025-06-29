# ---------------------------
# TERRAFORM AND PROVIDERS
# ---------------------------
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}

  tenant_id       = "7602ad0d-b3e4-4824-a88d-a49042a4adc4"
  subscription_id = "3a734e32-021d-4243-89ff-c3495e6aa4da"
}

# ---------------------------
# VARIABLES
# ---------------------------
variable "monika_lb" {
  type = map(object({
    name_rg          = string
    location         = string
    name_vnet        = string
    address_space    = list(string)
    name_snet        = string
    address_prefixes = list(string)
    name_pip         = string
    name_nic         = string
    name_vm          = string
  }))
}

# ---------------------------
# CLIENT CONFIG
# ---------------------------
data "azurerm_client_config" "current" {}

# ---------------------------
# RESOURCE GROUP
# ---------------------------
resource "azurerm_resource_group" "rg" {
  for_each = var.monika_lb

  name     = each.value.name_rg
  location = each.value.location
}

# ---------------------------
# VIRTUAL NETWORK
# ---------------------------
resource "azurerm_virtual_network" "vnet" {
  for_each            = var.monika_lb
  name                = each.value.name_vnet
  location            = each.value.location
  resource_group_name = each.value.name_rg
  address_space       = each.value.address_space
}

# ---------------------------
# SUBNET
# ---------------------------
resource "azurerm_subnet" "snet" {
  for_each = var.monika_lb

  name                 = each.value.name_snet
  resource_group_name  = each.value.name_rg
  virtual_network_name = each.value.name_vnet
  address_prefixes     = each.value.address_prefixes
}

# ---------------------------
# RANDOM PASSWORD
# ---------------------------
resource "random_password" "password" {
  for_each         = var.monika_lb
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# ---------------------------
# KEY VAULT
# ---------------------------
resource "azurerm_key_vault" "k_vault" {
  for_each                    = var.monika_lb
  name                        = "monikakv-${each.key}"
  location                    = each.value.location
  resource_group_name         = each.value.name_rg
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions     = ["Get", "Create", "Delete"]
    secret_permissions  = ["Get", "Set", "Restore", "List", "Delete"]
    storage_permissions = ["Get"]
  }
}

# ---------------------------
# KEY VAULT SECRET
# ---------------------------
resource "azurerm_key_vault_secret" "kv_secret" {
  for_each     = var.monika_lb
  name         = "monika-kvsr-${each.key}"
  value        = random_password.password[each.key].result
  key_vault_id = azurerm_key_vault.k_vault[each.key].id
}

# ---------------------------
# PUBLIC IP
# ---------------------------
resource "azurerm_public_ip" "pip3" {
  for_each            = var.monika_lb
  name                = each.value.name_pip
  resource_group_name = each.value.name_rg
  location            = each.value.location
  allocation_method   = "Static"
}

# ---------------------------
# NETWORK INTERFACE
# ---------------------------
resource "azurerm_network_interface" "nic" {
  for_each            = var.monika_lb
  name                = each.value.name_nic
  location            = each.value.location
  resource_group_name = each.value.name_rg

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.snet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip3[each.key].id
  }
}

# ---------------------------
# VIRTUAL MACHINE
# ---------------------------
resource "azurerm_linux_virtual_machine" "vm" {
  for_each                        = var.monika_lb
  name                            = each.value.name_vm
  resource_group_name             = each.value.name_rg
  location                        = each.value.location
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  admin_password                  = azurerm_key_vault_secret.kv_secret[each.key].value
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
