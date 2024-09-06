monika_lb = {

  vm01 = {
    name_nic       = "monika-nic"
    location       = "eastus"
    name_rg        = "monika-rg"
    name_snet      = "monika-snet"
    name_vnet      = "hub-rm-vnet"
    name_pip       = "monika-pip"
    name_vm        = "monika-vm"
    admin_username = "monika123"
    admin_password = "monika@123"

  }

  vm02 = {
    name_nic       = "monika-nic2"
    location       = "eastus"
    name_rg        = "monika-rg"
    name_snet      = "monika-snet2"
    name_vnet      = "spoke-rm-vnet2"
    name_pip       = "monika-pip2"
    name_vm        = "monika-vm2"
    admin_username = "monika123"
    admin_password = "monika@123"

  }



}