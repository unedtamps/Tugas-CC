#!/bin/bash

tofu init
sudo virsh net-define custom-network.xml
sudo virsh net-start custom-net
sudo virsh net-autostart custom-net
