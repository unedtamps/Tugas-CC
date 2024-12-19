output "db_vm_network_interface" {
  value = libvirt_domain.db_vm.network_interface
}

output "web_vm_network_interface" {
  value = libvirt_domain.web_vm.network_interface
}
