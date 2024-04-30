#!/bin/bash

print_header() {
    printf "Welcome to Package Manager\n"
}

print_menu() {
    printf "Please select an option:\n"
    printf "1. Update the package database and upgrade all packages.\n"
    printf "2. Remove a package and its dependencies.\n"
    printf "3. Clean the package cache.\n"
    printf "4. Clean up orphaned packages (requires 'deborphan').\n"
    printf "5. Check the dependencies of a package.\n"
}

check_package_dependencies() {
    printf "Enter the package name to check its dependencies: "
    read -r package_name
    printf "Checking dependencies for %s...\n" "$package_name"
    apt-cache depends "$package_name"
}

has_deborphan() {
    dpkg -l deborphan >/dev/null 2>&1
}

install_deborphan() {
    printf "The 'deborphan' package is required. Do you want to install it? (y/n): "
    read -r install_choice
    if [[ "$install_choice" == [yY] ]]; then
        sudo apt-get update
        sudo apt-get install deborphan
        return 0
    else
        return 1
    fi
}

execute_option() {
    local choice=$1
    if [[ $choice -eq 1 ]]; then
        printf "Updating package database and upgrading all packages...\n"
        sudo apt-get update && sudo apt-get upgrade
    elif [[ $choice -eq 2 ]]; then
        printf "Removing a package and its dependencies...\n"
        printf "Enter the package name you want to remove: "
        read -r package_name
        sudo apt-get remove --purge "$package_name" && sudo apt-get autoremove --purge
    elif [[ $choice -eq 3 ]]; then
        printf "Cleaning the package cache...\n"
        sudo apt-get autoclean
    elif [[ $choice -eq 4 ]]; then
        if has_deborphan; then
            printf "Cleaning up orphaned packages...\n"
            sudo apt-get autoremove && sudo apt-get purge $(deborphan)
        else
            install_deborphan || return
            execute_option "$choice"
        fi
    elif [[ $choice -eq 5 ]]; then
        check_package_dependencies
    else
        printf "Invalid option selected. Exiting.\n"
        exit 1
    fi
}

main() {
    print_header
    print_menu
    printf "Enter your choice (1/2/3/4/5): "
    read -r choice
    execute_option "$choice"
    printf "Operation completed.\n"
}

main
