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
