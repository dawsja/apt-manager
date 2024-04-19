#!/usr/bin/perl

use strict;
use warnings;

use Term::ANSIColor;

sub print_separator {
    print '-' x `tput cols`, "\n";
}

sub print_header {
    print_separator();
    print colored("        Welcome to Package Manager        ", 'blue'), "\n";
    print_separator();
}

sub print_menu {
    print "Please select an option:\n";
    print colored("1.", 'green'), " Update the package database and upgrade all packages.\n";
    print colored("2.", 'green'), " Remove a package and its dependencies.\n";
    print colored("3.", 'green'), " Clean the package cache.\n";
    print colored("4.", 'green'), " Clean up orphaned packages (requires 'deborphan').\n";
    print colored("5.", 'green'), " Check the dependencies of a package.\n";
}

sub check_package_dependencies {
    print "Enter the package name to check its dependencies: ";
    chomp(my $package_name = <STDIN>);
    print colored("Checking dependencies for $package_name...", 'yellow'), "\n";
    system("apt-cache depends $package_name");
}

sub has_deborphan {
    } elsif ($choice == 2) {
        print colored("Removing a package and its dependencies...", 'yellow'), "\n";
        print "Enter the package name you want to remove: ";
        chomp(my $package_name = <STDIN>);
        system("sudo apt-get remove --purge $package_name && sudo apt-get autoremove --purge");
    } elsif ($choice == 3) {
        print colored("Cleaning the package cache...", 'yellow'), "\n";
        system("sudo apt-get autoclean");
    } elsif ($choice == 4) {
        if (has_deborphan()) {
            print colored("Cleaning up orphaned packages...", 'yellow'), "\n";
            system("sudo apt-get autoremove && sudo apt-get purge \$(deborphan)");
        } else {
            return unless install_deborphan(); # Exit if deborphan is not installed and user doesn't want to install
            execute_option($choice); # Retry the operation after attempting to install deborphan
        }
    } elsif ($choice == 5) {
        check_package_dependencies();
    } else {
        print colored("Invalid option selected. Exiting.", 'red'), "\n";
        exit 1;
    }
}

sub main {
    print_header();
    print_menu();
    print "Enter your choice (1/2/3/4/5): ";
    chomp(my $choice = <STDIN>);
    execute_option($choice);
    print colored("Operation completed.", 'green'), "\n";
}

main();
