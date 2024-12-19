# Prerequisites
- [Ansible](https://www.ansible.com/)

# How to run
```bash
ansible-playbook playbook.yml
```

# Notes

Change the `ip-addr` in `hosts`, check the `ip-addr` of vm using:

```bash
virsh net-dhcp-leases custom-net
```

