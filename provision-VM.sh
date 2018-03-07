#!/bin/bash

set -e

usage() {
  cat <<EOF
  usage: $0 -a VM_IP_ADDRESS -u SSH_USERNAME

  This script configures the VM with Ubuntu 16.04 Server,
  described by its VM_IP_ADDRESS, to be a deployment server
  for Codethink's GCC.
  The script uses SSH_USERNAME user for ssh connection.

  OPTIONS:
    -h Show this message.
    -a IP address of the VM which is going to be configured.
    -u username for ssh connection.

  EXAMPLE:
    $0 -a 192.168.256.256 -u user
EOF
}

configure_vm() {
  pushd "$script_dir"
  echo -e "Connecting to $ssh_username@$vm_ip_address"
  ansible-playbook -i inventory user-creation.yml   \
                   -e "ansible_user=$ssh_username"  \
                   --ask-pass --ask-become-pass     \
                   -v
  ansible-playbook -i inventory deployment.yml        \
                   -e "ansible_user=deployment
                       ansible_ssh_pass=1ns3cur3
                       ansible_become_pass=1ns3cur3"  \
                   -v
  popd
}

main() {
  script_dir="$( cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd )"
  vm_ip_address=""
  ssh_username=""
  while getopts "ha:u:" option; do
    case $option in
      h)
        usage
        exit 0
        ;;
      a)
        vm_ip_address="$OPTARG"
        ;;
      u)
        ssh_username="$OPTARG"
        ;;
    esac
  done

  if [[ -n "$vm_ip_address" ]]; then
    echo "DEPLOYMENTSRV ansible_ssh_host=$vm_ip_address" > "$script_dir/inventory/hosts"
  else
    echo -e "ERROR: VM_IP_ADDRESS is mandatory\n"
    usage
    exit 1
  fi

  if [[ -z "$ssh_username" ]]; then
    echo -e "ERROR: SSH_USERNAME is mandatory\n"
    usage
    exit 1
  fi

  configure_vm
}

main "$@"
