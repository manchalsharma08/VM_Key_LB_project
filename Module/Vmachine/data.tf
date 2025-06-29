data "azurerm_subnet" "snet" {
    for_each = var.monika_lb
  name                 = each.value.name_snet
  virtual_network_name = each.value.name_vnet
  resource_group_name  = each.value.name_rg
}


data "azurerm_key_vault_secret" "vm-password" {
  name         = "kv-secret-name" # Replace with your actual secret name or use a variable
  key_vault_id = azurerm_key_vault.k_vault.id
}
