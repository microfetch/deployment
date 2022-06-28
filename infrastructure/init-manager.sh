/usr/bin/env bash

set -eu -o pipefail

apt update && apt install -qy python3-pip
pip install ansible docker
ansible-galaxy collection install community.docker
