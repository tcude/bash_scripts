#!/bin/bash

function welcome_message() {
    echo "###################################"
    echo "Welcome to the qm migrate script"
    echo -e "################################### \n"
}

function get_vm_id() {
    echo "Please enter the numerical ID of the VM you would like to migrate:"
    read -r vm_id
    echo -e "\nVM $vm_id will be migrated \n"
}

function choose_target_host() {
    echo "Next, please enter the name of the target host for migration. Your choices are:"
    ls /etc/pve/nodes
    read -r target_hostname
    echo -e "\nVM will be migrated to $target_hostname \n"
}

function choose_datastore() {
    echo "Lastly, please supply the name of the datastore you would like to migrate to"
    pvesm status
    read -r target_datastore
    echo -e "\n"
}

function confirm_migration() {
    echo "To confirm, you're migrating VM $vm_id to $target_hostname on datastore $target_datastore"
    read -r -p "Are you sure? [y/N] " response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        echo "Proceeding with the migration of $vm_id to $target_hostname on datastore $target_datastore"
        if qm migrate "$vm_id" "$target_hostname" --targetstorage "$target_datastore"
        then
            echo "Migration completed successfully."
        else
            echo "Migration failed."
            exit 1
        fi
    else
        echo "Cancelling"
        exit 1
    fi
}

function main() {
    welcome_message
    get_vm_id
    choose_target_host
    choose_datastore
    confirm_migration
}

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

main

