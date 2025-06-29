monika_lb = {
  dev = {
    name_rg          = "rg1-dev"
    location         = "eastus"
    name_vnet        = "vnet1-dev"
    address_space    = ["10.0.0.0/16"]
    name_snet        = "snet1-dev"
    address_prefixes = ["10.0.1.0/24"]
    name_pip         = "pip1-dev"
    name_nic         = "nic1-dev"
    name_vm          = "vm1-dev"
  }
}