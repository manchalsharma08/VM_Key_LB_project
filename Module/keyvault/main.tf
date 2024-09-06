data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "k_vault" {
  name                        = "monika-k_vault"
  location                    = "eastus"
  resource_group_name         = "monika-rg"
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id  ## its seperate for user, If u wnat to given permission for specification persion than y can copy object ID and paste , Same you go with group .

    key_permissions = [
      "Get","Create", "delete"
    ]

    secret_permissions = [
      "Get", "Set" ,"Restore" ,"List" ,"Delete"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}
### For Random Password create Used randod paasword resourse with Random provider
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
#############################
## for manual username and pass for key vault 
resource "azurerm_key_vault_secret" "k_valult_se" {  ## (1)for paasword asing by terrafor ,(2) manauly bhi kar sakte hai(portal se banalo)
  name         = "monika-kvs"
  value        =  "monika@1234"          ##  for manual passwork user----  "monika@1234"----
  key_vault_id = azurerm_key_vault.k_vault.id


}


## for random password for key vault using 
resource "azurerm_key_vault_secret" "k_valult_se2" {  ## (1)for paasword asing by terrafor ,(2) manauly bhi kar sakte hai(portal se banalo)
  name         = "monika-kvsr"
  value        =  random_password.password.result           ##  for manual passwork user----  "monika@1234"----
  key_vault_id = azurerm_key_vault.k_vault.id

  

}