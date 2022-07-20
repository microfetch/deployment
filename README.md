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

### Pipeline

Deployment happens via git clone and docker compose. 
First, deploy the pipeline by connecting to `microfetch-mgmt-1`:

```shell
git clone https://github.com/microfetch/microfetch-pipeline.git
```

You will be prompted for login details because the repository is private.
Create a Personal Access Token if you need to on GitHub (User Account > Settings > Developer Settings).

Once the repo is downloaded, `cd` into it and add the [environment files](https://github.com/microfetch/microfetch-pipeline/tree/dev/main#environment-files).

Finally, ensure the shell files have the necessary permissions and then build and launch the containers:

```shell
chmod +x */init.sh
docker compose up --build
```

### Assembler

The assembler deployment process is similar. 
Log into `microfetch-worker-1` and clone the repository, then set the shell file permissions:

```shell
git clone https://github.com/microfetch/microfetch-assembly.git
cd microfetch-assembly
chmod +x cron.sh
```

There is only one [environment file](https://github.com/microfetch/microfetch-assembly#envspaces) to set up. 
Once that is done, ensure that the `API_URL` is set correctly in the `docker-compose.yml` file and launch the container:

```shell
docker compose up --build
```
