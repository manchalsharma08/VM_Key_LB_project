data "azurerm_client_config" "current" {}
resource "random_password" "password" {
  for_each         = var.monika_lb
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault" "k_vault" {
  for_each                    = var.monika_lb
  name                        = "monikakv-${each.key}"
  location                    = each.value.location
  resource_group_name         = each.value.name_rg
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = false

  #आपके पास Recover permission दी गई है Terraform code के अंदर, लेकिन Azure Key Vault पर ये permission काम नहीं कर रही, क्योंकि:

  #आपने access_policy method यूज़ की है।

  #लेकिन Azure में अब RBAC (Role-Based Access Control) को ज्यादा support किया जाता है।

  #और आपकी Azure subscription में आप सिर्फ Contributor हैं, जिससे "Recover" जैसी high-level permission काम नहीं करेगी जब तक Key Vault Administrator role assign न किया गया हो। 
  #इसलिए, आपको Key Vault पर RBAC roles assign करने की जरूरत है।

#   # access_policy {
#   #   tenant_id = data.azurerm_client_config.current.tenant_id
#   #   object_id = data.azurerm_client_config.current.object_id

#   #   key_permissions     = ["Get", "Create", "Delete"]
#   #   secret_permissions  = ["Get", "Set", "Restore", "List", "Delete","Recover"]
#   #   storage_permissions = ["Get"]
#   # }
#   depends_on = [ random_password.password ]
# }
}
resource "azurerm_role_assignment" "kv_admin_role" {
  for_each             = var.monika_lb
  principal_id         = data.azurerm_client_config.current.object_id
  role_definition_name = "Key Vault Administrator"
  scope                = azurerm_key_vault.k_vault[each.key].id
}



resource "azurerm_key_vault_secret" "kv_secret" {
  for_each     = var.monika_lb
  name         = "monika-kvsr-${each.key}"
  value        = random_password.password[each.key].result
  key_vault_id = azurerm_key_vault.k_vault[each.key].id
    depends_on   = [azurerm_key_vault.k_vault , random_password.password]
}

output "keyvault_ids" {
  value = {
    for key, vault in azurerm_key_vault.k_vault :
    key => vault.id
  }
  depends_on = [ azurerm_key_vault_secret.kv_secret ]
}