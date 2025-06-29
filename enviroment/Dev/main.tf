module "rg" {
  source = "../../module/RG"

  monika_lb = var.manchal

}

module "vnet" {
  source     = "../../module/Vnetwork"
  monika_lb  = var.manchal
  depends_on = [module.rg]
}

module "snet" {
  source     = "../../module/Subnetwork"
  monika_lb  = var.manchal
  depends_on = [module.vnet]

}

module "kvaoult" {
  source = "../../Module/keyvault"
  providers = {
    azurerm = azurerm
    random  = random
  }
  monika_lb  = var.manchal
  depends_on = [module.snet]

}


# module "DB" {
# source = "../../Database"
# monika_lb = var.manchal
# }
module "vm" {
  source     = "../../module/Vmachine"
  monika_lb  = var.manchal
  depends_on = [module.snet, module.rg, module.vnet, module.kvaoult]
}


