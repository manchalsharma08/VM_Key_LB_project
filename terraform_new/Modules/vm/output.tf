output "vm_public_ips" {
  value = {
    for k, vm in azurerm_linux_virtual_machine.vm :
    k => {
      public_ip = azurerm_public_ip.pip3[k].ip_address
      username  = vm.admin_username
    }
  }
}