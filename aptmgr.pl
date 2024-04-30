#!/bin/bash

print_separator() {
    printf "%s\n" "$(printf -- '-%.0s' $(tput cols))"
}

print_header() {
    print_separator
    printf "\033[34m%-40s\033[0m\n" "        Welcome to Package Manager        "
    print_separator
}

print_menu() {
    printf "Please select an option:\n"
    printf "\033[32m1.\033[0m Update the package database and upgrade all packages.\n"
    printf "\033[32m2.\033[0m Remove a package and its dependencies.\n"
    printf "\033[32m3.\033[0m Clean the package cache.\n"
    printf "\033[32m4.\033[0m Clean up orphaned packages (requires 'deborphan').\n"
    printf "\033[32m5.\033[0m Check the dependencies of a package.\n"
}

check_package_dependencies() {
    printf "Enter the package name to check its dependencies: "
    read -r package_name
    printf "\033[33mChecking dependencies for %s...\033[0m\n" "$package_name"
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
        printf "\033[33mUpdating package database and upgrading all packages...\033[0m\n"
        sudo apt-get update && sudo apt-get upgrade
    elif [[ $choice -eq 2 ]]; then
        printf "\033[33mRemoving a package and its dependencies...\033[0m\n"
        printf "Enter the package name you want to remove: "
        read -r package_name
        sudo apt-get remove --purge "$package_name" && sudo apt-get autoremove --purge
    elif [[ $choice -eq 3 ]]; then
        printf "\033[33mCleaning the package cache...\033[0m\n"
        sudo apt-get autoclean
    elif [[ $choice -eq 4 ]]; then
        if has_deborphan; then
            printf "\033[33mCleaning up orphaned packages...\033[0m\n"
            sudo apt-get autoremove && sudo apt-get purge $(deborphan)
        else
            install_deborphan || return
            execute_option "$choice"
        fi
    elif [[ $choice -eq 5 ]]; then
        check_package_dependencies
    else
        printf "\033[31mInvalid option selected. Exiting.\033[0m\n"
        exit 1
    fi
}

main() {
    print_header
    print_menu
    printf "Enter your choice (1/2/3/4/5): "
    read -r choice
    execute_option "$choice"
    printf "\033[32mOperation completed.\033[0m\n"
}

main
