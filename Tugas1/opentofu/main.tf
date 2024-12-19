terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

data "template_file" "db_user_data" {
  template = file("config/db/user-data")
}

data "template_file" "db_network-config" {
  template = file("config/db/network-config")
}

data "template_file" "web_user_data" {
  template = file("config/web/user-data")
}

data "template_file" "web_network-config" {
  template = file("config/web/network-config")
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_cloudinit_disk" "db_cloud_init" {
  name      = "db_cloudinit.iso"
  user_data = data.template_file.db_user_data.rendered
  network_config = data.template_file.db_network-config.rendered
}

resource "libvirt_cloudinit_disk" "web_cloud_init" {
  name      = "web_cloudinit.iso"
  user_data = data.template_file.web_user_data.rendered
  network_config = data.template_file.web_network-config.rendered
}

resource "libvirt_volume" "db_vm_disk" {
  name   = "db_disk_vm.qcow2"
  pool   = "default"
  source = "./image/base-image.qcow2" # Path to your base image
  format = "qcow2"
}

resource "libvirt_volume" "web_vm_disk" {
  name   = "web_disk_vm.qcow2"
  pool   = "default"
  source = "./image/base-image.qcow2" # Path to your base image
  format = "qcow2"
}


resource "libvirt_domain" "db_vm" {
  name   = var.db_vm_name
  memory = var.db_vm_memory
  vcpu   = var.db_vm_vcpus 

  cloudinit = libvirt_cloudinit_disk.db_cloud_init.id

  disk {
    volume_id = libvirt_volume.db_vm_disk.id
  }

  network_interface {
    network_name = "custom-net" 
    wait_for_lease = true
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }
}

resource "libvirt_domain" "web_vm" {
  name   = var.web_vm_name
  memory = var.web_vm_memory
  vcpu   = var.web_vm_vcpus # Number of CPUs

  cloudinit = libvirt_cloudinit_disk.web_cloud_init.id

  disk {
    volume_id = libvirt_volume.web_vm_disk.id
  }

  network_interface {
    network_name = "custom-net" 
    wait_for_lease = true
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }
}
