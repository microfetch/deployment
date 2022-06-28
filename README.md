# Microfetch Installation Guide

## Components

Microfetch consists of two components:

1. A manager node that runs the primary application and web interface.
2. Worker node(s) that run the assembly tasks.

## Getting started

- Create server and manager nodes, and edit the inventory.ini file.
- Rsync this directory to the manager node amd bootstrap it.
```
# ssh into server
ssh -A root@{microfetch-mgmt-1}
```
- Bootstrap the servers (configure users etc.)
```
cd microfetch-deployment
chmod +x init-manager.sh
./init-manager.sh
ansible-playbook -i inventory.ini -u root bootstrap.yml
```
- Reboot all the servers to apply updates and the run the main ansible script.
```
ssh -A {username}@{microfetch-mgmt-1}
ansible-playbook -i inventory.ini main.yml
```
- Everything should now be up.

## Hints & Tips
Put something like this in your local `.ssh/config` (with correct IP addresses):
```
Host microfetch-mgmt-1
  Hostname 46.101.75.136
  User corin.yeats
  ControlMaster auto
  ControlPath ~/.ssh/sockets/%C
  ControlPersist 600
  ServerAliveInterval 300
  ServerAliveCountMax 2
# LocalForward 8000 microfetch-mgmt-1:8000
Host microfetch-worker-1
  Hostname 139.59.173.254
  User corin.yeats
  ControlMaster auto
  ControlPath ~/.ssh/sockets/%C
  ControlPersist 600
  ServerAliveInterval 300
  ServerAliveCountMax 2
```

## Deploying microfetch
TBD.
