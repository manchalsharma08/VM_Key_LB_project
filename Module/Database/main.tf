resource "azurerm_mssql_server" "monika-sdb" {
  for_each = var.monika_lb
  name                         = each.value.name_sdb
  resource_group_name          = each.value.name_rg
    location                     = each.value.location
     version                      = "12.0"
  administrator_login          = each.value.administrator_login
  administrator_login_password = each.value.administrator_login_password
}

resource "azurerm_mssql_database" "monika_bd" {
  for_each = var.monika_lb
  name           = each.value.name_db
  server_id      = azurerm_mssql_server.monika-sdb[each.key].id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  read_scale     = true
  sku_name       = "S0"
  zone_redundant = true
  enclave_type   = "VBS"

}