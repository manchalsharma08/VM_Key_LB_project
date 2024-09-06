resource "azurerm_resource_group" "rg" {
for_each = var.monika_lb

  name     = each.value.name_rg
  location = each.value.location
}