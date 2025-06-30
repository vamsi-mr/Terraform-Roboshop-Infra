#!/bin/bash

component=$1
dnf install ansible -y
ansible-pull -U https://github.com/vamsi-mr/Ansible-Roles.git -e component=$1 main.yaml