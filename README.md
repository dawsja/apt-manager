# Package Manager CLI Tool
This command-line interface (CLI) tool, written in Perl, provides a simple interface for managing packages on your system.

## Features
- Update the package database and upgrade all packages.
- Remove a package and its dependencies.
- Clean the package cache.
- Clean up orphaned packages (packages that were installed as dependencies but are no longer required by any installed package).
- Check the dependencies of a package.

You might need to run `chmod +x aptmgr.pl` then: `./aptmgr.pl` to execute the script.
