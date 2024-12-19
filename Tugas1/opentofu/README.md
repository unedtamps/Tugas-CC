# Create VM

This repository will create 2 VMs using qemu and libvirt and automated with opentofu.

## Prerequisites

1. Opentofu

    See the [installation guide](https://opentofu.org/docs/intro/install/deb/) for more information.

2. Qemu

   - Install qemu and required tools

   ```bash
    sudo apt install qemu qemu-kvm qemu-utils
   ```

   - Check if the installation is successful

   ```bash
    qemu-system-x86_64 --version
   ```


3. Libvirt

    - Install Libvirt and related tools

    ```bash
    sudo apt install libvirt-daemon-system libvirt-clients
    ```

    - Install  `virt-manager`

    ```bash
    sudo apt install virt-manager
    ```

    - Start and enable the libvirt service

    ```bash
    sudo systemctl start libvirtd
    sudo systemctl enable libvirtd
    ```

    - Verify the installation

    ```bash
    virsh list --all
    ```

4. Ubuntu image
    
    - Download the Ubuntu image

    Choose the Ubuntu version you want to use and download the image from the
    [official website](https://cloud-images.ubuntu.com/).

    - Convert the image to qcow2 format

    ```bash
    qemu-img convert -f <source_format> -O qcow2 <source_image> <output_image>
    ```

    example:
    ```bash
     qemu-img convert -O qcow2 ubuntu-22.04-server-cloudimg-amd64.img base-image.qcow2
    ```

    resize:
    ```bash
     qemu-img resize image/base-image.qcow2 +5G 
    ```

    Place the image in the `images` directory.


## Usage

   1. Edit the .vm-settings file to configure the VMs.

   2. Run `startup.sh` only once
   2. Run `up.sh` to create the VMs.
   3. Run `down.sh` to delete the VMs.

## Problem
   If you encounter this error:

``` bash
│ Error: error creating libvirt domain: internal error: process exited while connecting to monitor: 2024-11-21T18:24:39.908631Z qemu-system-x86_64: -blockdev {"driver":"file","filename":"/var/
lib/libvirt/images/vm-disk.qcow2","node-name":"libvirt-1-storage","auto-read-only":true,"discard":"unmap"}: Could not open '/var/lib/libvirt/images/vm-disk.qcow2': Permission denied
```
  Add this line to the `/etc/libvirt/qemu.conf`

  `security_driver = "none"`

  Then restart the libvirt service:

``` bash
sudo systemctl restart libvirtd
```
