# data "azurerm_client_config" "current" {}

# resource "azurerm_key_vault" "k-vault" {
#   for_each = var.monika_lb
#   name                        = "monika-k-vault"
#   location                    = "eastus"
#   resource_group_name         = each.value.name_rg
#   enabled_for_disk_encryption = true
#   tenant_id                   = data.azurerm_client_config.current.tenant_id
  
#   purge_protection_enabled    = false

#   sku_name = "standard"

#   access_policy {
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = data.azurerm_client_config.current.object_id  ## its seperate for user, If u wnat to given permission for specification persion than y can copy object ID and paste , Same you go with group .

#     key_permissions = [
#       "Get","Create", "delete"
#     ]

#     secret_permissions = [
#       "Get", "Set" ,"Restore" ,"List" ,"Delete"
#     ]

#     storage_permissions = [
#       "Get",
#     ]
#   }
# }
# ### For Random Password create Used randod paasword resourse with Random provider
# resource "random_password" "password" {
#   for_each         = var.monika_lb
#   length           = 16
#   special          = true
#   override_special = "!#$%&*()-_=+[]{}<>:?"
# }

# #############################
# ## for manual username and pass for key vault 
# # resource "azurerm_key_vault_secret" "k_valult_se" {  ## (1)for paasword asing by terrafor ,(2) manauly bhi kar sakte hai(portal se banalo)
# #   name         = "monika-kvs"
# #   value        =  "monika@1234"          ##  for manual passwork user----  "monika@1234"----
# #   key_vault_id = azurerm_key_vault.k_vault.id


# # }


# ## for random password for key vault using 
# resource "azurerm_key_vault_secret" "k-valult-se2" {
#   for_each     = var.monika_lb
#   name         = "monika-kvsr-${each.key}"                        # Unique name per vault
#   value = random_password.password[each.key].result
#   key_vault_id = azurerm_key_vault.k-vault[each.key].id

#   depends_on = [
#     azurerm_key_vault.k-vault,
#     random_password.password
#   ]
# }



# ---------------------------
# PROVIDER CONFIG FOR MODULE
# ---------------------------
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

data "azurerm_client_config" "current" {}

# ---------------------------
# GENERATE RANDOM PASSWORD PER INSTANCE
# ---------------------------
resource "random_password" "password" {
  for_each         = var.monika_lb
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# ---------------------------
# CREATE KEY VAULT PER RG
# ---------------------------
resource "azurerm_key_vault" "k_vault" {
  for_each                    = var.monika_lb
  name                        = "monikakv-${each.key}" # Valid name (3-24 chars, alphanumeric & hyphen)
  location                    = "eastus"
  resource_group_name         = each.value.name_rg
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = ["Get", "Create", "Delete"]
    secret_permissions = ["Get", "Set", "Restore", "List", "Delete"]
    storage_permissions = ["Get"]
  }
}

# ---------------------------
# STORE RANDOM PASSWORD AS SECRET
# ---------------------------
resource "azurerm_key_vault_secret" "kv_secret" {
  for_each     = var.monika_lb
  name         = "monika-kvsr-${each.key}"
  value        = random_password.password[each.key].result
  key_vault_id = azurerm_key_vault.k_vault[each.key].id

  depends_on = [
    azurerm_key_vault.k_vault,
    random_password.password
  ]
}
