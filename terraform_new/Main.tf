module "network" {
  source    = "./modules/network"
  monika_lb = var.monika_lb

}

module "keyvault" {
  source    = "./modules/keyvault"
  monika_lb = var.monika_lb
  depends_on = [ module.network ]

}

module "vm" {
  source       = "./modules/vm"
  monika_lb    = var.monika_lb
  keyvault_ids = module.keyvault.keyvault_ids
  subnet_ids   = module.network.subnet_ids
  depends_on = [ module.keyvault , module.network ]

}

output "vm_info" {
  value = module.vm.vm_public_ips
}

